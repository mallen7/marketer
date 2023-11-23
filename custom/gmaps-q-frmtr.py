import re
import os

def load_valid_options(filename):
    """ Load valid options from a given .md file. """
    try:
        with open(f'/opt/google-maps-scraper/{filename}', 'r') as file:
            return [line.strip() for line in file.readlines() if line.strip()]
    except FileNotFoundError:
        print(f"Warning: {filename} file not found.")
        return []

def extract_and_validate_field(input_text, field_name, valid_options):
    """ Extract and validate the value of a field from the input text. """
    pattern = rf"{field_name}\s*=\s*([\w\s]+)"
    match = re.search(pattern, input_text)
    if match:
        value = match.group(1).strip()
        if value in valid_options:
            return value
    return None

def format_query(input_text, categories, countries):
    """ Format the query based on extracted and validated fields. """
    formatted_query = f"queries = [\"{input_text}\"]\nGmaps.places(queries"

    # Extract and validate category
    category = extract_and_validate_field(input_text, "category_in", categories)
    if category:
        formatted_query += f", category_in=[Gmaps.Category.{category}]"

    # Extract and validate country
    country = extract_and_validate_field(input_text, "country", countries)
    if country:
        formatted_query += f", country='{country}'"

    # Add other fields as needed

    formatted_query += ")"
    return formatted_query

def main():
    categories = load_valid_options("categories.md")
    countries = load_valid_options("countries.md")

    input_text = input("Enter your query in normal text: ")
    scraper_query = format_query(input_text, categories, countries)
    print("\nFormatted Query:\n", scraper_query)

if __name__ == "__main__":
    main()
