"""
Sync Tool

This script provides a CLI for synchronizing files between a local machine and an external drive.
It supports selecting specific folders or syncing all predefined folders in one go.

Examples of usage:
1. Interactive Menu:
    python sync_tool.py menu
    - Select an external drive
    - Displays a menu of folders to choose from.
    - Prompts the user to 'push' (upload) or 'pull' (download).
    - Prompts if you want to do a dry run (no changes made).
"""

import typer
import subprocess
import os
from typing import List, Tuple, Union
from InquirerPy import prompt

app = typer.Typer()

# Define hardcoded source and destination directories
sync_options = {
    "Music": [
        ("~/Music/00 DJ Music", "Music/00 DJ Music"),
        ("~/Music/01 DJ Sets Recorded", "Music/01 DJ Sets Recorded"),
    ],
    "Documents": [("~/Documents", "Documents")],
}
# add an option for a flattened combination of the values above
sync_options["Sync All"] = sync_options["Music"] + sync_options["Documents"]

def sync_directory(external_drive: str, source: str, destination: str, action: str, dry_run: bool):
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

def sync(external_drive: str, sync_item: str, action: str, dry_run: bool = False):
    """
    Sync a specific item between the source and the external drive.

    - sync_item: The item to sync (e.g., 'documents', 'photos').
    - action: Whether to 'push' or 'pull'.
    - dry_run: If True, perform a dry run without making any changes.
    """
    if sync_item not in sync_options:
        typer.echo(typer.style("Invalid item! Choose from: " + ", ".join(sync_options.keys()), fg=typer.colors.RED))
        raise typer.Exit(code=1)

    for source, destination in sync_options[sync_item]:
        sync_directory(external_drive, source, destination, action, dry_run)

    typer.echo(typer.style(f"All {sync_options[sync_item].count}  completed.", fg=typer.colors.BRIGHT_BLUE))

def get_external_drives():
    """
    Get a list of available external drives.
    """
    drives = [f"/Volumes/{d}" for d in os.listdir("/Volumes") if not d.startswith("Macintosh HD")]
    return drives

@app.command()
def menu():
    """
    Interactive menu to select an item and action (push or pull).
    """
    typer.echo(typer.style("Welcome to the Sync Tool!", fg=typer.colors.CYAN, bold=True))

    drives = get_external_drives()
    if not drives:
        typer.echo(typer.style("Please connect an external drive.", fg=typer.colors.RED))
        raise typer.Exit(code=1)

    choices = list(sync_options.keys())

    questions = [
        {
            "type": "list",
            "name": "drive",
            "message": "Select an external drive:",
            "choices": drives,
        },
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
    sync(answers['drive'], answers["sync_item"], answers["action"], answers["dry_run"])

if __name__ == "__main__":
    app()
