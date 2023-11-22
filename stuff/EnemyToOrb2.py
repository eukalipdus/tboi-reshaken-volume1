# FOR ANYONE ELSE USING THIS
# The files need to be in a format like:
#       Name: Enemy1
#       ID: 1
#       Variant: 2
#       Element: Water
#
#       Name: Enemy 2
#       ID: 5
#       Variant: 6
#       Subtype: 7
#       Element: Fire
#
# Casing doesnt matter, any spaces and the order you put them in don't matter,
# but you need to put an empty line between different enemies.

input_files = [
    "./stuff/retribution.txt"
]

def clean_line(line, preffix):
    no_preffix = line.removeprefix(preffix)
    return no_preffix.strip()

for input_file_path in input_files:
    only_file_name = input_file_path.removesuffix(".txt")
    output_file_path = f"{only_file_name}_output.txt"
    output_lines = []

    with open(input_file_path, 'r') as input_file:
        current_name = None
        current_id = None
        current_variant = None
        current_subtype = None
        current_element = None

        for line in input_file:
            line = line.strip().lower()

            if line.startswith("name:"):
                current_name = clean_line(line, "name:")
            elif line.startswith("id:"):
                current_id = clean_line(line, "id:")
            elif line.startswith("variant:"):
                current_variant = clean_line(line, "variant:")
            elif line.startswith("subtype:"):
                current_subtype = clean_line(line, "subtype:")
            elif line.startswith("element:"):
                current_element = clean_line(line, "element:").upper()
            elif len(line) == 0:
                if not (current_element is None or current_id is None or current_variant is None or current_name is None):
                    if current_subtype is None:
                        output_lines.append(f"{{orb = MilkshakeVol1.enums.Orbs.{current_element}, type = {current_id}, variant = {current_variant}}}, -- {current_name}")
                    else:
                        output_lines.append(f"{{orb = MilkshakeVol1.enums.Orbs.{current_element}, type = {current_id}, variant = {current_variant}, subtype = {current_subtype}}}, -- {current_name}")
                
                current_name = None
                current_id = None
                current_variant = None
                current_subtype = None
                current_element = None

    with open(output_file_path, 'w') as output_file:
        output_file.write('\n'.join(output_lines))

    print(f"{only_file_name} done!")

print("Done!")