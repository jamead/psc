import re

def parse_registers(file_path):
    with open(file_path, 'r') as file:
        content = file.read()

    # Regex pattern to match register blocks
    pattern = re.compile(r'reg\s*{\s*(.*?)\s*}\s*(\w+)\s*@0x([0-9A-Fa-f]+);', re.DOTALL)

    # Extract and parse each register block
    parsed_data = []
    for match in pattern.finditer(content):
        body, name, address = match.groups()
        description = re.search(r'desc\s*=\s*"(.*?)";', body)
        parsed_data.append((f"#DEFINE {name.upper()}", f"0X{address.upper()}", f"// {description.group(1)}" if description else ""))

    return parsed_data

# Example usage
if __name__ == "__main__":
    file_path = "pl_regs.rdl"  # Change this to your file name
    parsed_data = parse_registers(file_path)

    for name, address, desc in parsed_data:
        print(f"{name:<29} {address:<10}{desc}")
