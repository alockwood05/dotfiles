"""
Sync Tool

This script provides a CLI for synchronizing files between a local machine and an external drive.
It supports selecting specific folders or syncing all predefined folders in one go.

Examples of usage:
1. Interactive Menu:
    python sync_tool.py menu
    - Displays a menu of folders to choose from.
    - Prompts the user to 'push' (upload) or 'pull' (download).

2. Sync a Specific Folder:
    python sync_tool.py sync documents push
    - Synchronizes the 'documents' folder from the local source to the external drive.
    python sync_tool.py sync photos pull
    - Synchronizes the 'photos' folder from the external drive to the local source.

3. Sync All Folders:
    python sync_tool.py sync-all push
    - Uploads all predefined folders to the external drive.
    python sync_tool.py sync-all pull
    - Downloads all predefined folders from the external drive to the local source.

Predefined folders:
- 'documents': Local path and external drive path for documents
- 'photos': Local path and external drive path for photos
- 'videos': Local path and external drive path for videos

Notes:
- Ensure `rsync` is installed on your system.
- Modify the `SYNCLIST` dictionary to include your specific folder paths.
"""

import typer
import subprocess
import os
from typing import List, Tuple, Union
from InquirerPy import prompt

app = typer.Typer()

# Define hardcoded source and destination directories
SYNCLIST = {
    "Music": [
        ("~/Music/00 DJ Music", "Music/00 DJ Music"),
        ("~/Music/01 DJ Sets Recorded", "Music/01 DJ Sets Recorded"),
    ],
    "Documents": [("~/Documents", "Documents")],
}

def get_external_drives():
    """
    Get a list of available external drives.
    """
    drives = [f"/Volumes/{d}" for d in os.listdir("/Volumes") if not d.startswith("Macintosh HD")]
    return drives

def select_external_drive():
    """
    Prompt the user to select an external drive from the available drives.
    """
    drives = get_external_drives()
    if not drives:
        typer.echo(typer.style("Please connect an external drive.", fg=typer.colors.RED))
        raise typer.Exit(code=1)

    questions = [
        {
            "type": "list",
            "name": "drive",
            "message": "Select an external drive:",
            "choices": drives,
        }
    ]

    answers = prompt(questions)
    selected_drive = answers["drive"]
    typer.echo(f"Selected external drive: {selected_drive}")
    return selected_drive

def sync_directory(source: str, destination: str, action: str, dry_run: bool, external_drive: str):
    rsync_command = ["rsync", "-avh", "--stats"]
    if dry_run:
        rsync_command.append("--dry-run")

    source = os.path.expanduser(source)
    destination = os.path.join(external_drive, destination)

    if action == "push":
        typer.echo(typer.style(f"Pushing files from {source} to {destination}...", fg=typer.colors.GREEN))
        rsync_command.extend([f"{source}/", f"{destination}/"])
    elif action == "pull":
        typer.echo(typer.style(f"Pulling files from {destination} to {source}...", fg=typer.colors.GREEN))
        rsync_command.extend([f"{destination}/", f"{source}/"])
    else:
        typer.echo(typer.style("Invalid action! Use 'push' or 'pull'.", fg=typer.colors.RED))
        raise typer.Exit(code=1)

    subprocess.run(rsync_command)
    typer.echo(typer.style("Sync completed.", fg=typer.colors.BRIGHT_BLUE))

@app.command()
def sync(sync_item: str, action: str, dry_run: bool = False):
    """
    Sync a specific item between the source and the external drive.

    - sync_item: The item to sync (e.g., 'documents', 'photos').
    - action: Whether to 'push' or 'pull'.
    - dry_run: If True, perform a dry run without making any changes.
    """
    external_drive = select_external_drive()

    if sync_item not in SYNCLIST:
        typer.echo(typer.style("Invalid item! Choose from: " + ", ".join(SYNCLIST.keys()), fg=typer.colors.RED))
        raise typer.Exit(code=1)

    for source, destination in SYNCLIST[sync_item]:
        sync_directory(source, destination, action, dry_run, external_drive)

@app.command()
def sync_all(action: str, dry_run: bool = False):
    """
    Sync all items in the predefined list.

    - action: Whether to 'push' or 'pull'.
    - dry_run: If True, perform a dry run without making any changes.
    """
    external_drive = select_external_drive()

    if action not in ["push", "pull"]:
        typer.echo(typer.style("Invalid action! Use 'push' or 'pull'.", fg=typer.colors.RED))
        raise typer.Exit(code=1)

    for sync_item, paths in SYNCLIST.items():
        typer.echo(typer.style(f"Syncing {sync_item} ({action})...", fg=typer.colors.YELLOW))
        for source, destination in paths:
            sync_directory(source, destination, action, dry_run, external_drive)

    typer.echo(typer.style("All items synced.", fg=typer.colors.BRIGHT_BLUE))

@app.command()
def menu():
    """
    Interactive menu to select an item and action (push or pull).
    """
    typer.echo(typer.style("Welcome to the Sync Tool!", fg=typer.colors.CYAN, bold=True))

    choices = list(SYNCLIST.keys()) + ["Sync All"]
    questions = [
        {
            "type": "list",
            "name": "sync_item",
            "message": "Select an item to sync:",
            "choices": choices,
        },
        {
            "type": "list",
            "name": "action",
            "message": "Would you like to 'push' or 'pull'?",
            "choices": ["push", "pull"],
        },
        {
            "type": "confirm",
            "name": "dry_run",
            "message": "Would you like to perform a dry run?",
            "default": False,
        },
    ]

    answers = prompt(questions)
    typer.echo(f"Selected item: {answers['sync_item']}")
    typer.echo(f"Selected action: {answers['action']}")
    typer.echo(f"Dry run: {answers['dry_run']}")

    if answers["sync_item"] == "Sync All":
        sync_all(answers["action"], answers["dry_run"])
    else:
        sync(answers["sync_item"], answers["action"], answers["dry_run"])

if __name__ == "__main__":
    app()
