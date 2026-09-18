"""Project-wide test checks. This file defines checks, so changing it needs the user's OK."""

import ast
import inspect
import textwrap
from collections.abc import Callable
from functools import cache

import pytest


def _is_assertion(node: ast.AST) -> bool:
    match node:
        case ast.Assert():
            return True
        case ast.Call(func=ast.Attribute(attr=name) | ast.Name(id=name)):
            return name.startswith("assert") or name in {"raises", "warns"}
        case _:
            return False


@cache
def _has_assertion(test: Callable[..., object]) -> bool:
    tree = ast.parse(textwrap.dedent(inspect.getsource(test)))
    return any(_is_assertion(node) for node in ast.walk(tree))


@pytest.hookimpl(tryfirst=True)
def pytest_runtest_call(item: pytest.Item) -> None:
    """Every test must assert something, like `expect-expect` in the TypeScript template."""
    if isinstance(item, pytest.Function) and not _has_assertion(item.obj):
        pytest.fail(
            f"{item.name} has no assertions. Assert something, use pytest.raises or "
            "pytest.warns, or call an assert_* helper.",
            pytrace=False,
        )
