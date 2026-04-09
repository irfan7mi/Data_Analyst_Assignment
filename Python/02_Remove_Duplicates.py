def remove_duplicates(input_str):
    unique_str = ""
    for char in input_str:
        if char not in unique_str:
            unique_str += char
    return unique_str

test_str = "programming"
print(remove_duplicates(test_str)) # Output: progamin