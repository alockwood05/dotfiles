import pytest
from typer.testing import CliRunner
from unittest.mock import patch
from syncfiles import app

runner = CliRunner()

@pytest.fixture
def mock_subprocess_run():
    with patch("subprocess.run") as mock_run:
        yield mock_run

def test_sync_push(mock_subprocess_run):
    result = runner.invoke(app, ["sync", "documents", "push"])
    assert result.exit_code == 0
    assert "Pushing files from /path/to/source/documents to /path/to/external/documents..." in result.output
    mock_subprocess_run.assert_called_once_with(["rsync", "-avh", "--progress", "/path/to/source/documents/", "/path/to/external/documents/"])

def test_sync_pull(mock_subprocess_run):
    result = runner.invoke(app, ["sync", "photos", "pull"])
    assert result.exit_code == 0
    assert "Pulling files from /path/to/external/photos to /path/to/source/photos..." in result.output
    mock_subprocess_run.assert_called_once_with(["rsync", "-avh", "--progress", "/path/to/external/photos/", "/path/to/source/photos/"])

def test_sync_invalid_folder():
    result = runner.invoke(app, ["sync", "invalid_folder", "push"])
    assert result.exit_code != 0
    assert "Invalid folder! Choose from: documents, photos, videos" in result.output

def test_sync_invalid_action():
    result = runner.invoke(app, ["sync", "documents", "invalid_action"])
    assert result.exit_code != 0
    assert "Invalid action! Use 'push' or 'pull'." in result.output

def test_sync_all_push(mock_subprocess_run):
    result = runner.invoke(app, ["sync-all", "push"])
    assert result.exit_code == 0
    assert "Syncing documents (push)..." in result.output
    assert "Syncing photos (push)..." in result.output
    assert "Syncing videos (push)..." in result.output
    assert "All folders synced." in result.output
    assert mock_subprocess_run.call_count == 3

def test_sync_all_pull(mock_subprocess_run):
    result = runner.invoke(app, ["sync-all", "pull"])
    assert result.exit_code == 0
    assert "Syncing documents (pull)..." in result.output
    assert "Syncing photos (pull)..." in result.output
    assert "Syncing videos (pull)..." in result.output
    assert "All folders synced." in result.output
    assert mock_subprocess_run.call_count == 3

def test_menu_sync_all_push(mock_subprocess_run):
    result = runner.invoke(app, ["menu"], input="4\npush\n")
    assert result.exit_code == 0
    assert "Syncing documents (push)..." in result.output
    assert "Syncing photos (push)..." in result.output
    assert "Syncing videos (push)..." in result.output
    assert "All folders synced." in result.output
    assert mock_subprocess_run.call_count == 3

def test_menu_sync_specific_folder(mock_subprocess_run):
    result = runner.invoke(app, ["menu"], input="1\npush\n")
    assert result.exit_code == 0
    assert "Pushing files from /path/to/source/documents to /path/to/external/documents..." in result.output
    mock_subprocess_run.assert_called_once_with(["rsync", "-avh", "--progress", "/path/to/source/documents/", "/path/to/external/documents/"])
