import os

# Set the directory path
directory = "./mana_costs"

# Iterate over each file in the directory
for filename in os.listdir(directory):
    # Check if ':' is in the filename
    if ':' in filename:
        # Create the new filename by replacing ':' with '_'
        new_filename = filename.replace(':', '_')
        # Construct full file paths
        old_file = os.path.join(directory, filename)
        new_file = os.path.join(directory, new_filename)
        # Rename the file
        os.rename(old_file, new_file)
        print(f'Renamed: "{filename}" to "{new_filename}"')

print("All files processed.")
