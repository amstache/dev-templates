import logging
from pathlib import Path

import pytest
from hypothesis import given
from hypothesis import strategies as st
from pydantic import ValidationError

from app import main
from app.example import load_user, slugify


def test_load_user(tmp_path: Path) -> None:
    (tmp_path / "user.json").write_text('{"name": "Ana", "email": "ana@example.com"}')
    assert load_user(tmp_path).name == "Ana"


def test_load_user_rejects_missing_fields(tmp_path: Path) -> None:
    (tmp_path / "user.json").write_text('{"name": "Ana"}')
    with pytest.raises(ValidationError):
        load_user(tmp_path)


@given(st.text())
def test_slugify_never_contains_whitespace(text: str) -> None:
    assert not any(c.isspace() for c in slugify(text))


def test_main_logs_slug(caplog: pytest.LogCaptureFixture) -> None:
    caplog.set_level(logging.INFO)
    main()
    assert "hello-world" in caplog.text
