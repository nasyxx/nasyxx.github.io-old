#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Life's pathetic, have fun ("▔□▔)/hi~♡ Nasy.

Excited without bugs::

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

@author: Nasy https://nasy.moe <Nasy>
@date: Jun 3, 2018
@email: echo bmFzeXh4QGdtYWlsLmNvbQo= | base64 -D
@filename: add_header.py
@Last modified time: Jun 16, 2018
@license: MIT

There are more things in heaven and earth, Horatio, than are dreamt.
 --  From "Hamlet"
"""
# Standard Library
import re
from typing import Dict, List
from pathlib import Path
from itertools import takewhile


def clean_line(line: str) -> str:
    """Clean line."""
    if "date" in line.lower():
        return (
            line.replace("\n", "")
            .replace("<", "")
            .replace(">", "")
            .replace("#+", "")
        )

    return line.replace("\n", "").replace("#+", "")


def get_all_org_files() -> List[Path]:
    """Get all org files."""
    return list(Path("blogs").glob("*.org"))


def get_meta_from_org(path: Path) -> Dict[str, str]:
    """Get metadata from org file."""
    res = {}
    with path.open() as f:
        for line in takewhile(lambda x: x != "\n", f):
            k, *vs = re.split(r":\s*", clean_line(line))
            kl, v = k.lower(), "".join(vs)
            if kl in (
                "author",
                "title",
                "language",
                "summary",
                "comment",
                "ctitle",
            ):
                res[kl] = v
            elif kl in ("tags", "categories"):
                res[kl] = ", ".join(sorted(re.split(r",\s*", v)))
            elif kl == "date" and v:
                res[kl] = v[0:10]
            elif kl == "href":
                res[kl] = v + ".org"
        return res


def write_out(path: Path) -> None:
    """Write out org file."""
    metadata = get_meta_from_org(path)
    Path("posts").mkdir(exist_ok=True)
    with (Path("posts") / metadata.get("href", path.name)).open(
        "w"
    ) as o, path.open() as f:
        o.write("------------------\n")
        for k, v in metadata.items():
            o.write(k + ": " + v + "\n")
        o.write("------------------\n")
        o.write(f.read())


def hack_about() -> None:
    """Hack about.html."""
    Path("posts/about.org").replace("about.org")


def main() -> None:
    """Run the main function."""
    list(map(write_out, get_all_org_files()))
    hack_about()


if __name__ == "__main__":
    main()
