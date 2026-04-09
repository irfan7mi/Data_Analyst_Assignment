def convert_minutes(n):
    hours = n // 60
    minutes = n % 60
    
    h_label = "hr" if hours == 1 else "hrs"
    return f"{hours} {h_label} {minutes} minutes"

n = int(input())
print(convert_minutes(130)) # 2 hrs 10 minutes
print(convert_minutes(110)) # 1 hr 50 minutes