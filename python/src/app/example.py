"""Example code showing the project's conventions. Delete once you have real code."""

from pathlib import Path

from pydantic import BaseModel


class User(BaseModel):
    name: str
    email: str


def load_user(directory: Path) -> User:
    """Validate external data at the boundary instead of passing dicts around."""
    return User.model_validate_json((directory / "user.json").read_text())


def slugify(text: str) -> str:
    return "-".join(text.lower().split())
