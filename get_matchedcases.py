import re
import csv
import sys
from pathlib import Path


def parse_coq_file(filepath):
    """
    Parse a Coq file and extract matched cases from Frequency sections.
    
    Returns a list of dictionaries with keys:
    - frequency: The frequency section number (e.g., "Frequency1", "Frequency2")
    - section: The section number within the frequency (e.g., 1, 2, 3)
    - size: The size value from the match pattern
    - stack1: The stack1 value from the match pattern
    - stack2: The stack2 value from the match pattern
    - weight: The weight value after =>
    """
    with open(filepath, 'r') as f:
        content = f.read()
    
    results = []
    
    # Find all Frequency sections
    frequency_pattern = r'\(\*\s*Frequency(\d+)\s*\*\)'
    frequency_matches = list(re.finditer(frequency_pattern, content))
    
    for freq_idx, freq_match in enumerate(frequency_matches):
        frequency_num = freq_match.group(1)
        frequency_name = f"Frequency{frequency_num}"
        
        # Determine the end of this frequency section
        # It ends at the next Frequency section or end of file
        start_pos = freq_match.end()
        if freq_idx + 1 < len(frequency_matches):
            end_pos = frequency_matches[freq_idx + 1].start()
        else:
            end_pos = len(content)
        
        freq_section = content[start_pos:end_pos]
        
        # Find all numbered sections within this frequency
        section_pattern = r'\(\*\s*(\d+)\s*\*\)\s*\(match'
        section_matches = list(re.finditer(section_pattern, freq_section))
        
        for sect_idx, sect_match in enumerate(section_matches):
            section_num = sect_match.group(1)
            
            # Determine the end of this section
            # It ends at the next section or end of frequency section
            sect_start = sect_match.end()
            if sect_idx + 1 < len(section_matches):
                sect_end = section_matches[sect_idx + 1].start()
            else:
                sect_end = len(freq_section)
            
            section_content = freq_section[sect_start:sect_end]
            
            # Extract match cases
            # Pattern: | (num, num, num) => num
            case_pattern = r'\|\s*\((\d+),\s*(\d+),\s*(\d+)\)\s*=>\s*(\d+)'
            case_matches = re.finditer(case_pattern, section_content)
            
            for case_match in case_matches:
                size_val = int(case_match.group(1))
                stack1_val = int(case_match.group(2))
                stack2_val = int(case_match.group(3))
                weight_val = int(case_match.group(4))
                
                results.append({
                    'section': int(section_num),
                    'size': size_val,
                    'stack1': stack1_val,
                    'stack2': stack2_val,
                    'weight': weight_val
                })
    
    return results


def write_csv(data, output_path):
    """Write the extracted data to a CSV file."""
    if not data:
        print("No data to write.")
        return
    
    fieldnames = ['section', 'size', 'stack1', 'stack2', 'weight']
    
    with open(output_path, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)
    
    print(f"Wrote {len(data)} rows to {output_path}")


def main():
    if len(sys.argv) < 2:
        print("Usage: python get_matchedcases.py <coq_file> [output.csv]")
        print("\nExample:")
        print("  python get_matchedcases.py tuning-output/.../trained_Generator.v output.csv")
        sys.exit(1)
    
    input_file = sys.argv[1]
    
    # Default output file name
    if len(sys.argv) >= 3:
        output_file = sys.argv[2]
    else:
        input_path = Path(input_file)
        output_file = input_path.parent / f"{input_path.stem}_matched_cases.csv"
    
    print(f"Parsing {input_file}...")
    data = parse_coq_file(input_file)
    
    print(f"Found {len(data)} matched cases.")
    write_csv(data, output_file)


if __name__ == "__main__":
    main()
