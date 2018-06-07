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

* author: Nasy https://nasy.moe <Nasy>
* date: May 3, 2018
* email: echo bmFzeXh4QGdtYWlsLmNvbQo= | base64 -D
* filename: new_blog.py
* Last modified time: May 3, 2018
* license: MIT

There are more things in heaven and earth, Horatio, than are dreamt.
 --  From "Hamlet"
"""
from typing import Tuple

from fire import Fire
from pendulum import now


def blog(title: str) -> None:
    """Create a essay blog."""
    with open(f"blogs/{title}.org", "w") as f:
        f.write("\n".join([
            f"#+TITLE: {title}",
            "#+DATE: "
            f"{now().format('<YYYY-MM-DD ddd>')}",
            "#+AUTHOR: Nasy",
            "#+TAGS: 花, flower, hana, 随笔, essay",
            "#+CATEGORIES: Flower, Eassy",
            "#+SUMMARY: ",
        ]))


def hana(title: str, kw: Tuple[str, ...] = None,
         cat: Tuple[str, ...] = None) -> None:
    """Create a blog with hana as its keywords."""
    with open(f"blogs/{title}.org", "w") as f:
        f.write("\n".join([
            f"#+TITLE: {title}",
            "#+DATE: "
            f"{now().format('<YYYY-MM-DD ddd>')}",
            "#+AUTHOR: Nasy",
            "#+TAGS: 花, flower, hana"
            f"{', ' + ', '.join(map(str, kw)) if kw else ''}",
            "#+CATEGORIES: Flower"
            f"{', ' + ', '.join(map(str, cat)) if cat else ''}",
            "#+SUMMARY: ",
        ]))


def grass(title: str, kw: Tuple[str, ...] = None,
          cat: Tuple[str, ...] = None) -> None:
    """Create a blog with grass as its keywords."""
    with open(f"blogs/{title}.org", "w") as f:
        f.write("\n".join([
            f"#+TITLE: {title}",
            "#+DATE: "
            f"{now().format('<YYYY-MM-DD ddd>')}",
            "#+AUTHOR: Nasy",
            "#+TAGS: 草, grass"
            f"{', ' + ', '.join(map(str, kw)) if kw else ''}",
            "#+CATEGORIES: Grass"
            f"{', ' + ', '.join(map(str, cat)) if cat else ''}",
            "#+SUMMARY: ",
        ]))


def fish(title: str, kw: Tuple[str, ...] = None,
         cat: Tuple[str, ...] = None) -> None:
    """Create a blog with fish as its keywords."""
    with open(f"blogs/{title}.org", "w") as f:
        f.write("\n".join([
            f"#+TITLE: {title}",
            "#+DATE: "
            f"{now().format('<YYYY-MM-DD ddd>')}",
            "#+AUTHOR: Nasy",
            "#+TAGS: 鱼, fish"
            f"{', ' + ', '.join(map(str, kw)) if kw else ''}",
            "#+CATEGORIES: fish"
            f"{', ' + ', '.join(map(str, cat)) if cat else ''}",
            "#+SUMMARY: ",
        ]))


if __name__ == '__main__':
    Fire()
