{-
 Excited without bugs, have fun ("▔□▔)/hi~♡ Nasy.
 -----------------------------------------------
 |
 |             *         *
 |                  .                .
 |           .
 |     *                      ,
 |                   .
 |
 |                               *
 |          |\___/|
 |          )    -(             .              '
 |         =\  -  /=
 |           )===(       *
 |          /   - \
 |          |-    |
 |         /   -   \     0.|.0
 |  NASY___\__( (__/_____(\=/)__+1s____________
 |  ______|____) )______|______|______|______|_
 |  ___|______( (____|______|______|______|____
 |  ______|____\_|______|______|______|______|_
 |  ___|______|______|______|______|______|____
 |  ______|______|______|______|______|______|_
 |  ___|______|______|______|______|______|____

There are more things in heaven and earth, Horatio, than are dreamt.
   -- From "Hamlet"
--------------------------------------------------------------------------------

-}
{-# LANGUAGE OverloadedStrings #-}
--------------------------------------------------------------------------------
-- |
-- @Author             : Nasy https://nasy.moe <Nasy>
-- @Date               : May 30, 2018
-- @Email              : echo bmFzeXh4QGdtYWlsLmNvbQo= | base64 -D
-- @Filename           : Main.hs
-- @Last modified by   : Nasy
-- @Last modified time : Jun 15, 2018
-- @License            : MIT
--
--------------------------------------------------------------------------------
module Main (main) where
import           Control.Monad                  ( mplus )
import           Data.List                      ( isSuffixOf
                                                , isPrefixOf
                                                , intersperse
                                                )
import           Data.Maybe                     ( fromMaybe )
--------------------------------------------------------------------------------
import           Data.Monoid                    ( (<>) )
import           Hakyll
import           Hakyll.Web.Tags                ( tagsFieldWith )
import           Network.HTTP.Base              ( urlEncode )
import           System.FilePath.Posix          ( takeBaseName
                                                , takeDirectory
                                                , (</>)
                                                , takeFileName
                                                )
import           System.Process                 ( system )
import           Text.Blaze.Html                ( toHtml
                                                , toValue
                                                , (!)
                                                )
import qualified Text.Blaze.Html5              as H
import qualified Text.Blaze.Html5.Attributes   as A
                                                ( href )
import           Text.Pandoc                    ( Pandoc
                                                , Block(..)
                                                , WriterOptions(..)
                                                )
import           Text.Pandoc.Options
import           Text.Pandoc.Walk               ( walk )




--------------------------------------------------------------------------------
config :: Configuration
config = Configuration
    { destinationDirectory = "public"
    , storeDirectory       = "_cache"
    , tmpDirectory         = "_cache/tmp"
    , providerDirectory    = "."
    , ignoreFile           = ignoreFile'
    , deployCommand        = "echo 'No deploy command specified' && exit 1"
    , deploySite           = system . deployCommand
    , inMemoryCache        = True
    , previewHost          = "127.0.0.1"
    , previewPort          = 8000
    }
  where
    ignoreFile' path | "." `isPrefixOf` fileName    = True
                     | "#" `isPrefixOf` fileName    = True
                     | "~" `isSuffixOf` fileName    = True
                     | ".swp" `isSuffixOf` fileName = True
                     | otherwise                    = False
        where fileName = takeFileName path




--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith config $ do

    match "images/*" $ do
        route idRoute
        compile copyFileCompiler

    match "styles/main.css" $ do
        route idRoute
        compile compressCssCompiler

    match "static/*" $ do
        route idRoute
        compile copyFileCompiler

    match "scripts/*" $ do
        route idRoute
        compile copyFileCompiler

    match "templates/*" $ compile templateCompiler

    ---------------------------------------------------------------------------
    -- build up tags and categories
    tags       <- buildTags "posts/*.org" (fromCapture "tags/*/index.html")
    categories <- buildCategories' "posts/*.org"
                                   (fromCapture "categories/*/index.html")

    tagsRules tags $ \tag pattern' -> do
        let showing = "Posts tagged \"" ++ tag ++ "\""
            title   = tag
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll pattern'
            let
                ctx =
                    constField "showing" showing
                        <> constField "title" title
                        <> constField "', '"  "', '"
                        <> listField
                               "posts"
                               (  postCtxWithTags tags
                               <> postCtxWithCats categories
                               <> postCtx
                               )
                               (return posts)
                        <> defaultContext

            makeItem ""
                >>= loadAndApplyTemplate t_tags    ctx
                >>= loadAndApplyTemplate t_default ctx
                >>= relativizeUrls
                >>= cleanIndexHtmls

    tagsRules categories $ \cat pattern' -> do
        let showing = "Posts category \"" ++ cat ++ "\""
            title   = cat
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll pattern'
            let
                ctx =
                    constField "showing" showing
                        <> constField "title" title
                        <> constField "', '"  "', '"
                        <> listField
                               "posts"
                               (  postCtxWithTags tags
                               <> postCtxWithCats categories
                               <> postCtx
                               )
                               (return posts)
                        <> defaultContext

            makeItem ""
                >>= loadAndApplyTemplate t_cats    ctx
                >>= loadAndApplyTemplate t_default ctx
                >>= relativizeUrls
                >>= cleanIndexHtmls
    ---------------------------------------------------------------------------


    match "posts/*.org" $ do
        route cleanRoute
        compile
            $   myPandocCompiler
            >>= loadAndApplyTemplate
                    t_post
                    (  constField "in-post" "true"
                    <> postCtxWithTags tags
                    <> postCtxWithCats categories
                    <> postCtx
                    )
            >>= loadAndApplyTemplate
                    t_default
                    (  postCtxWithTags tags
                    <> postCtxWithCats categories
                    <> postCtx
                    )
            >>= relativizeUrls
            >>= cleanIndexUrls

    match "About.org" $ do
        route cleanRoute
        compile
            $   myPandocCompiler
            >>= loadAndApplyTemplate
                    t_post
                    (  constField "in-post" "true"
                    <> postCtxWithTags tags
                    <> postCtxWithCats categories
                    <> postCtx
                    )
            >>= loadAndApplyTemplate
                    t_default
                    (  postCtxWithTags tags
                    <> postCtxWithCats categories
                    <> postCtx
                    )
            >>= relativizeUrls
            >>= cleanIndexUrls

    create ["tags/index.html"] $ do
        route idRoute
        compile $ do
            let ctx =
                    cloudCtx tags
                        <> constField "title" "Tags"
                        <> constField "', '"  "', '"
                        <> defaultContext
            makeItem ""
                >>= loadAndApplyTemplate t_cloud   ctx
                >>= loadAndApplyTemplate t_default ctx
                >>= relativizeUrls
                >>= cleanIndexUrls

    create ["categories/index.html"] $ do
        route idRoute
        compile $ do
            let ctx =
                    cloudCtx categories
                        <> constField "title" "Categories"
                        <> constField "', '"  "', '"
                        <> defaultContext
            makeItem ""
                >>= loadAndApplyTemplate t_cloud   ctx
                >>= loadAndApplyTemplate t_default ctx
                >>= relativizeUrls
                >>= cleanIndexUrls

    create ["index.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*.org"
            let
                indexCtx =
                    listField
                            "posts"
                            (  postCtxWithTags tags
                            <> postCtxWithCats categories
                            <> postCtx
                            )
                            (return posts)
                        <> constField "title"   "Nasy Land"
                        <> constField "showing" "Writings"
                        <> constField "index"   "true"
                        <> constField "', '"    "', '"
                        <> defaultContext

            makeItem ""
                >>= loadAndApplyTemplate t_arc     indexCtx
                >>= loadAndApplyTemplate t_default indexCtx
                >>= relativizeUrls
                >>= cleanIndexUrls
  where
    t_post    = "templates/post.html"
    t_default = "templates/default.html"
    t_tags    = "templates/tags.html"
    t_cats    = "templates/categories.html"
    t_arc     = "templates/archive.html"
    t_cloud   = "templates/cloud.html"




-------------------------------------------------------------------------------
-- | Clean Route.
cleanRoute :: Routes
cleanRoute = customRoute createIndexRoute
  where
    createIndexRoute ident =
        takeDirectory p </> (urlEString . takeBaseName) p </> "index.html"
        where p = toFilePath ident


cleanIndexUrls :: Item String -> Compiler (Item String)
cleanIndexUrls = return . fmap (withUrls cleanIndex)


cleanIndexHtmls :: Item String -> Compiler (Item String)
cleanIndexHtmls = return . fmap (replaceAll pattern' replacement)
  where
    pattern'    = "/index.html"
    replacement = const "/"


cleanIndex :: String -> String
cleanIndex url | idx `isSuffixOf` url = take (length url - length idx) url
               | otherwise            = url
    where idx = "index.html"




-------------------------------------------------------------------------------
-- | Custom compiler
shiftHeaders :: Int -> Pandoc -> Pandoc
shiftHeaders i = walk go
  where
    go (Header l a inl) = Header (l + i) a inl
    go x                = x

myPandocCompiler :: Compiler (Item String)
myPandocCompiler =
    pandocCompilerWithTransform defaultHakyllReaderOptions withTocMath
        $ shiftHeaders 1
  where
    mathExtensions =
        [Ext_tex_math_dollars, Ext_tex_math_double_backslash, Ext_latex_macros]
    defaultWExtensions = writerExtensions defaultHakyllWriterOptions
    customWExtensions  = extensionsFromList mathExtensions <> defaultWExtensions
    withTocMath        = defaultHakyllWriterOptions
        { writerExtensions      = customWExtensions
        , writerHTMLMathMethod  = MathJax ""
        , writerTableOfContents = True
        , writerTemplate        =
            Just "<nav class='text-table-of-contents'>$toc$</nav>\n$body$"
        }
-------------------------------------------------------------------------------
-- | Ctx
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y"
        <> constField "showing" "Writings"
        <> defaultContext


postCtxWithTags :: Tags -> Context String
postCtxWithTags = tagsField "tags"


postCtxWithCats :: Tags -> Context String
postCtxWithCats = categoryField' "categories"


cloudCtx :: Tags -> Context String
cloudCtx = tagCloudField "cloud" 80 125




-------------------------------------------------------------------------------
-- | Custom Get Metadata

-- | Multi-categories. It should support both Chinese and English categories
-- Magic change the `buildCategories` from the source of Hakyll
getCategory' :: MonadMetadata m => Identifier -> m [String]
getCategory' identifier = do
    metadata <- getMetadata identifier
    return
        $       fromMaybe []
        $       lookupStringList "categories" metadata
        `mplus` (map trim . splitAll "," <$> lookupString "categories" metadata)

categoryField' :: String     -- ^ Destination key
               -> Tags       -- ^ Tags
               -> Context a  -- ^ Context
categoryField' =
    tagsFieldWith getCategory' simpleRenderLink (mconcat . intersperse ", ")


simpleRenderLink :: String -> Maybe FilePath -> Maybe H.Html
simpleRenderLink _ Nothing = Nothing
simpleRenderLink tag (Just filePath) =
    Just $ H.a ! A.href (toValue $ toUrl filePath) $ toHtml tag


buildCategories' :: MonadMetadata m
                 => Pattern
                 -> (String -> Identifier)
                 -> m Tags
buildCategories' = buildTagsWith getCategory'

-------------------------------------------------------------------------------
-- | Custom Functions

replaceSpace :: String -> String
replaceSpace = map repl
  where
    repl ' ' = '-'
    repl c   = c

-- | I am not really happy with this, though gitalk makes me have to do like this.
urlEString :: String -> String
urlEString = urlEncode . replaceSpace
