# FOR ANYONE ELSE USING THIS
# This expects the file to be called the same as the orb enum it corresponds to.
# You'll also have to replace "orb = enums" with "orb = MilkshakeVol1.enums" in the FF file
# although a simple ctrl+f replacement works well enough

orb = "unholy"
orb = orb.upper()

input_file_path = "{}.txt".format(orb.lower())
output_file_path = "{}_output.txt".format(orb.lower())

output_lines = []

with open(input_file_path, 'r') as input_file:
    for line in input_file:
        line = line.strip()
        
        # Check if the line starts with a number
        if not line or not line[0].isdigit():
            output_lines.append("")
            continue
        
        parts = line.split(' ')
        if len(parts) >= 2:
            entity_name = ' '.join(parts[1:]).strip()
            entity_name = entity_name.removeprefix("--")

            entity_parts = parts[0].split('.')

            if len(entity_parts) == 2:
                entity_type = entity_parts[0]
                entity_variant = entity_parts[1]

                output_line = (
                    "{{orb = enums.Orbs.{}, type = {}, variant = {} }}, --{}"
                    .format(orb, entity_type, entity_variant, entity_name)
                )
                output_lines.append(output_line)
            elif len(entity_parts) == 3:
                entity_type = entity_parts[0]
                entity_variant = entity_parts[1]
                entity_subtype = entity_parts[2]

                output_line = (
                    "{{orb = enums.Orbs.{}, type = {}, variant = {}, subtype = {}}}, --{}"
                    .format(orb, entity_type, entity_variant, entity_subtype, entity_name)
                )
                output_lines.append(output_line)

with open(output_file_path, 'w') as output_file:
    output_file.write('\n'.join(output_lines))