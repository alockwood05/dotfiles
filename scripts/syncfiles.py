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
- Modify the `FOLDERS` dictionary to include your specific folder paths.
"""

import typer
import subprocess
from typing import List

app = typer.Typer()

# Define hardcoded source and destination directories
FOLDERS = {
    "documents": ("/path/to/source/documents", "/path/to/external/documents"),
    "photos": ("/path/to/source/photos", "/path/to/external/photos"),
    "videos": ("/path/to/source/videos", "/path/to/external/videos"),
}

@app.command()
def sync(folder: str, action: str, dry_run: bool = False):
    """
    Sync a specific folder between the source and the external drive.

    - folder: The folder to sync (e.g., 'documents', 'photos').
    - action: Whether to 'push' or 'pull'.
    - dry_run: If True, perform a dry run without making any changes.
    """
    if folder not in FOLDERS:
        typer.echo(typer.style("Invalid folder! Choose from: " + ", ".join(FOLDERS.keys()), fg=typer.colors.RED))
        raise typer.Exit(code=1)

    source, destination = FOLDERS[folder]
    rsync_command = ["rsync", "-avh", "--progress"]
    if dry_run:
        rsync_command.append("--dry-run")

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
    typer.echo(typer.style("Sync completed.", fg=typer.colors.BLUE))


@app.command()
def sync_all(action: str, dry_run: bool = False):
    """
    Sync all folders in the predefined list.

    - action: Whether to 'push' or 'pull'.
    - dry_run: If True, perform a dry run without making any changes.
    """
    if action not in ["push", "pull"]:
        typer.echo(typer.style("Invalid action! Use 'push' or 'pull'.", fg=typer.colors.RED))
        raise typer.Exit(code=1)

    for folder, (source, destination) in FOLDERS.items():
        typer.echo(typer.style(f"Syncing {folder} ({action})...", fg=typer.colors.YELLOW))
        rsync_command = ["rsync", "-avh", "--progress"]
        if dry_run:
            rsync_command.append("--dry-run")

        if action == "push":
            rsync_command.extend([f"{source}/", f"{destination}/"])
        elif action == "pull":
            rsync_command.extend([f"{destination}/", f"{source}/"])

        subprocess.run(rsync_command)

    typer.echo(typer.style("All folders synced.", fg=typer.colors.BLUE))


@app.command()
def menu():
    """
    Interactive menu to select a folder and action (push or pull).
    """
    typer.echo(typer.style("Welcome to the Sync Tool!", fg=typer.colors.CYAN, bold=True))
    typer.echo("Folders:")
    for idx, folder in enumerate(FOLDERS.keys(), 1):
        typer.echo(f"  {idx}. {folder}")

    typer.echo(f"  {len(FOLDERS) + 1}. Sync All")

    choice = typer.prompt("Select an option (1 for first folder, 2 for second, etc.)")
    try:
        choice = int(choice)
        if choice == len(FOLDERS) + 1:
            action = typer.prompt("Would you like to 'push' or 'pull'?")
            dry_run = typer.confirm("Would you like to perform a dry run?")
            sync_all(action, dry_run)
        elif 1 <= choice <= len(FOLDERS):
            folder = list(FOLDERS.keys())[choice - 1]
            action = typer.prompt(f"Would you like to 'push' or 'pull' for {folder}?")
            dry_run = typer.confirm("Would you like to perform a dry run?")
            sync(folder, action, dry_run)
        else:
            typer.echo(typer.style("Invalid option!", fg=typer.colors.RED))
    except ValueError:
        typer.echo(typer.style("Please enter a valid number.", fg=typer.colors.RED))


if __name__ == "__main__":
    app()
