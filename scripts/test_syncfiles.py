import pytest
from unittest.mock import patch, call
import os
from syncfiles import menu, get_external_drives
import click

@pytest.fixture
def mock_get_external_drives():
    with patch("syncfiles.get_external_drives") as mock:
        yield mock

@pytest.fixture
def mock_prompt():
    with patch("syncfiles.prompt") as mock:
        yield mock

@pytest.fixture
def mock_subprocess_run():
    with patch("syncfiles.subprocess.run") as mock:
        yield mock

@pytest.fixture
def mock_listdir():
    with patch("syncfiles.os.listdir") as mock:
        yield mock

MUSIC_SRC1 = os.path.expanduser("~/Music/00 DJ Music/")
MUSIC_DEST1 = "/Volumes/Drive1/Music/00 DJ Music/"
MUSIC_SRC2 = os.path.expanduser("~/Music/01 DJ Sets Recorded/")
MUSIC_DEST2 = "/Volumes/Drive1/Music/01 DJ Sets Recorded/"
DOCS_SRC = os.path.expanduser("~/Documents/")
DOCS_DEST = "/Volumes/Drive1/Documents/"

def test_sync_tool_menu_music_push_dry_run(mock_subprocess_run, mock_get_external_drives, mock_prompt):
    mock_get_external_drives.return_value = ["/Volumes/Drive1"]
    mock_prompt.return_value = { "drive": "/Volumes/Drive1", "sync_item": "Music", "action": "push", "dry_run": True }
    # Run the menu function
    menu()
    # Verify the rsync command was called with the correct arguments
    mock_subprocess_run.assert_has_calls([
        call(["rsync", "-avh", "--stats", "--dry-run", MUSIC_SRC1, MUSIC_DEST1]),
        call(["rsync", "-avh", "--stats", "--dry-run", MUSIC_SRC2, MUSIC_DEST2]),
    ], any_order=True)

def test_sync_tool_menu_documents_pull(mock_subprocess_run, mock_get_external_drives, mock_prompt):
    mock_get_external_drives.return_value = ["/Volumes/Drive1"]
    mock_prompt.return_value = { "drive": "/Volumes/Drive1", "sync_item": "Documents", "action": "pull", "dry_run": False }
    # Run the menu function
    menu()
    # Verify the rsync command was called with the correct arguments
    mock_subprocess_run.assert_called_once_with(["rsync", "-avh", "--stats", DOCS_DEST, DOCS_SRC])

def test_sync_tool_menu_invalid_item(mock_get_external_drives, mock_prompt):
    mock_get_external_drives.return_value = ["/Volumes/Drive1"]
    mock_prompt.return_value = { "drive": "/Volumes/Drive1", "sync_item": "InvalidItem", "action": "push", "dry_run": False }
    # Run the menu function and capture the output
    with pytest.raises(click.exceptions.Exit) as excinfo:
        menu()
        assert excinfo.value.code == 1
