import pytest
from typer.testing import CliRunner
from unittest.mock import patch
from syncfiles import app, get_external_drives, sync_directory

runner = CliRunner()

@pytest.fixture
def mock_subprocess_run():
    with patch("subprocess.run") as mock_run:
        yield mock_run

@pytest.fixture
def mock_prompts():
    with patch("typer.prompt") as mock_prompt, patch("typer.confirm") as mock_confirm:
        yield mock_prompt, mock_confirm

@pytest.fixture
def mock_external_drives():
    with patch("syncfiles.get_external_drives") as mock_get_drives:
        mock_get_drives.return_value = ["/Volumes/ExternalDrive"]
        yield mock_get_drives

def test_sync_push(mock_subprocess_run, mock_prompts, mock_external_drives):
    mock_prompt, mock_confirm = mock_prompts
    mock_prompt.side_effect = [1]
    result = runner.invoke(app, ["sync", "Documents", "push", "--dry-run"])
    assert result.exit_code == 0
    assert "Pushing files from /~/Documents to /Volumes/ExternalDrive/Documents..." in result.output
    mock_subprocess_run.assert_called_once_with(["rsync", "-avh", "--stats", "--dry-run", "/~/Documents/", "/Volumes/ExternalDrive/Documents/"])

def test_sync_pull(mock_subprocess_run, mock_prompts, mock_external_drives):
    mock_prompt, mock_confirm = mock_prompts
    mock_prompt.side_effect = [1]
    result = runner.invoke(app, ["sync", "Music", "pull", "--dry-run"])
    assert result.exit_code == 0
    assert "Pulling files from /Volumes/ExternalDrive/Music/00 DJ Music to /~/Music/00 DJ Music..." in result.output
    mock_subprocess_run.assert_any_call(["rsync", "-avh", "--stats", "--dry-run", "/Volumes/ExternalDrive/Music/00 DJ Music/", "/~/Music/00 DJ Music/"])
    mock_subprocess_run.assert_any_call(["rsync", "-avh", "--stats", "--dry-run", "/Volumes/ExternalDrive/Music/01 DJ Sets Recorded/", "/~/Music/01 DJ Sets Recorded/"])

def test_sync_invalid_folder(mock_prompts, mock_external_drives):
    mock_prompt, mock_confirm = mock_prompts
    mock_prompt.side_effect = [1]
    result = runner.invoke(app, ["sync", "invalid_folder", "push", "--dry-run"])
    assert result.exit_code != 0
    assert "Invalid item! Choose from: Music, Documents" in result.output

def test_sync_invalid_action(mock_prompts, mock_external_drives):
    mock_prompt, mock_confirm = mock_prompts
    mock_prompt.side_effect = [1]
    result = runner.invoke(app, ["sync", "Documents", "invalid_action", "--dry-run"])
    assert result.exit_code != 0
    assert "Invalid action! Use 'push' or 'pull'." in result.output

def test_sync_all_push(mock_subprocess_run, mock_prompts, mock_external_drives):
    mock_prompt, mock_confirm = mock_prompts
    mock_prompt.side_effect = [1]
    result = runner.invoke(app, ["sync-all", "push", "--dry-run"])
    assert result.exit_code == 0
    assert "Syncing Music (push)..." in result.output
    assert "Syncing Documents (push)..." in result.output
    assert "All items synced." in result.output
    assert mock_subprocess_run.call_count == 3

def test_sync_all_pull(mock_subprocess_run, mock_prompts, mock_external_drives):
    mock_prompt, mock_confirm = mock_prompts
    mock_prompt.side_effect = [1]
    result = runner.invoke(app, ["sync-all", "pull", "--dry-run"])
    assert result.exit_code == 0
    assert "Syncing Music (pull)..." in result.output
    assert "Syncing Documents (pull)..." in result.output
    assert "All items synced." in result.output
    assert mock_subprocess_run.call_count == 3

def test_menu_sync_all_push(mock_subprocess_run, mock_prompts, mock_external_drives):
    mock_prompt, mock_confirm = mock_prompts
    mock_prompt.side_effect = ["3", "push", 1]
    mock_confirm.return_value = False
    result = runner.invoke(app, ["menu"])
    assert result.exit_code == 0
    assert "Syncing Music (push)..." in result.output
    assert "Syncing Documents (push)..." in result.output
    assert "All items synced." in result.output
    assert mock_subprocess_run.call_count == 3

def test_menu_sync_specific_folder(mock_subprocess_run, mock_prompts, mock_external_drives):
    mock_prompt, mock_confirm = mock_prompts
    mock_prompt.side_effect = ["2", "push", 1]
    mock_confirm.return_value = False
    result = runner.invoke(app, ["menu"])
    assert result.exit_code == 0
    assert "Pushing files from /~/Documents to /Volumes/ExternalDrive/Documents..." in result.output
    mock_subprocess_run.assert_called_once_with(["rsync", "-avh", "--stats", "/~/Documents/", "/Volumes/ExternalDrive/Documents/"])

def test_no_external_drives(monkeypatch):
    """
    Test that the script exits if there are no external drives.
    """
    monkeypatch.setattr('syncfiles.get_external_drives', lambda: [])
    result = runner.invoke(app, ["sync", "Documents", "push", "--dry-run"])
    assert result.exit_code != 0
    assert "Please connect an external drive." in result.output

def test_sync_directory_with_external_drive(monkeypatch):
    """
    Test that the external drive is prepended to the destination path when syncing.
    """
    external_drive = "/Volumes/ExternalDrive"
    source = "/~/Documents"
    destination = "Documents"
    action = "push"
    dry_run = True

    def mock_subprocess_run(command):
        assert command == ["rsync", "-avh", "--stats", "--dry-run", f"{source}/", f"{external_drive}/{destination}/"]

    monkeypatch.setattr('subprocess.run', mock_subprocess_run)
    sync_directory(source, destination, action, dry_run, external_drive)

def test_sync_push_no_dry_run(mock_subprocess_run, mock_prompts, mock_external_drives):
    mock_prompt, mock_confirm = mock_prompts
    mock_prompt.side_effect = [1]
    result = runner.invoke(app, ["sync", "Documents", "push"])
    assert result.exit_code == 0
    assert "Pushing files from /~/Documents to /Volumes/ExternalDrive/Documents..." in result.output
    mock_subprocess_run.assert_called_once_with(["rsync", "-avh", "--stats", "/~/Documents/", "/Volumes/ExternalDrive/Documents/"])

def test_sync_pull_no_dry_run(mock_subprocess_run, mock_prompts, mock_external_drives):
    mock_prompt, mock_confirm = mock_prompts
    mock_prompt.side_effect = [1]
    result = runner.invoke(app, ["sync", "Music", "pull"])
    assert result.exit_code == 0
    assert "Pulling files from /Volumes/ExternalDrive/Music/00 DJ Music to /~/Music/00 DJ Music..." in result.output
    mock_subprocess_run.assert_any_call(["rsync", "-avh", "--stats", "/Volumes/ExternalDrive/Music/00 DJ Music/", "/~/Music/00 DJ Music/"])
    mock_subprocess_run.assert_any_call(["rsync", "-avh", "--stats", "/Volumes/ExternalDrive/Music/01 DJ Sets Recorded/", "/~/Music/01 DJ Sets Recorded/"])

def test_sync_all_push_no_dry_run(mock_subprocess_run, mock_prompts, mock_external_drives):
    mock_prompt, mock_confirm = mock_prompts
    mock_prompt.side_effect = [1]
    result = runner.invoke(app, ["sync-all", "push"])
    assert result.exit_code == 0
    assert "Syncing Music (push)..." in result.output
    assert "Syncing Documents (push)..." in result.output
    assert "All items synced." in result.output
    assert mock_subprocess_run.call_count == 3

def test_sync_all_pull_no_dry_run(mock_subprocess_run, mock_prompts, mock_external_drives):
    mock_prompt, mock_confirm = mock_prompts
    mock_prompt.side_effect = [1]
    result = runner.invoke(app, ["sync-all", "pull"])
    assert result.exit_code == 0
    assert "Syncing Music (pull)..." in result.output
    assert "Syncing Documents (pull)..." in result.output
    assert "All items synced." in result.output
    assert mock_subprocess_run.call_count == 3

def test_menu_sync_all_push_no_dry_run(mock_subprocess_run, mock_prompts, mock_external_drives):
    mock_prompt, mock_confirm = mock_prompts
    mock_prompt.side_effect = ["3", "push", 1]
    mock_confirm.return_value = False
    result = runner.invoke(app, ["menu"])
    assert result.exit_code == 0
    assert "Syncing Music (push)..." in result.output
    assert "Syncing Documents (push)..." in result.output
    assert "All items synced." in result.output
    assert mock_subprocess_run.call_count == 3

def test_menu_sync_specific_folder_no_dry_run(mock_subprocess_run, mock_prompts, mock_external_drives):
    mock_prompt, mock_confirm = mock_prompts
    mock_prompt.side_effect = ["Documents", "push", False]
    mock_confirm.return_value = False
    result = runner.invoke(app, ["menu"])
    assert result.exit_code == 0
    assert "Pushing files from /~/Documents to /Volumes/ExternalDrive/Documents..." in result.output
    mock_subprocess_run.assert_called_once_with(["rsync", "-avh", "--stats", "/~/Documents/", "/Volumes/ExternalDrive/Documents/"])
