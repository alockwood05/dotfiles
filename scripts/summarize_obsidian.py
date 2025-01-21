import os
import argparse

dail_entries_root = os.path.join(os.path.expanduser("~"), "Library", "Mobile Documents", "iCloud~md~obsidian", "Documents", "unimaginable.life", "daily")

def extract_and_combine_journal_entries(input_folder, output_file):
    """
    Combines specific content from journal entries in a folder into a single Markdown file.
    Extracts content between "# Journal Writing" and "# Desire Docket" in each file.

    Args:
        input_folder (str): Path to the folder containing journal files.
        output_file (str): Path to save the combined Markdown file.
    """
    full_input_folder = os.path.join(dail_entries_root, input_folder)

    # Get a sorted list of all text/Markdown files in the folder
    files = sorted([f for f in os.listdir(full_input_folder) if f.endswith(('.md'))])

    with open(output_file, 'w', encoding='utf-8') as outfile:
        for file in files:
            file_path = os.path.join(input_folder, file)
            with open(file_path, 'r', encoding='utf-8') as infile:
                content = infile.read()

                # Extract content between "# Journal Writing" and "# Desire Docket"
                start_tag = "# Journal Writing"
                end_tag = "# Desire Docket"

                start_idx = content.find(start_tag)
                end_idx = content.find(end_tag)

                if start_idx != -1 and end_idx != -1:
                    # Extract relevant content
                    extracted_content = content[start_idx + len(start_tag):end_idx].strip()

                    # Write to the output file in the desired format
                    outfile.write(f"{file}\n")
                    outfile.write(f"{extracted_content}\n\n")
                    outfile.write("---\n\n")  # Separator for entries
                else:
                    print(f"Skipped {file}: Missing required headings.")

    print(f"Extracted content saved to {output_file}")

def main():
    # Create argument parser
    parser = argparse.ArgumentParser(description="Combine journal entries into a single Markdown file.")
    parser.add_argument("input_folder", type=str, help="Path to the folder containing journal files.")
    parser.add_argument("output_file", type=str, help="Path to save the combined Markdown file.")

    # Parse arguments
    args = parser.parse_args()
    args.output_file = args.output_file or f"{args.input_folder.replace('/','-')}_compiled.md"

    # Call the function with parsed arguments
    extract_and_combine_journal_entries(args.input_folder, args.output_file)

if __name__ == "__main__":
    main()
