# Convert minutes into hours and minutes

def convert_minutes(minutes):
    hrs = minutes // 60
    mins = minutes % 60
    return f"{hrs} hrs {mins} minutes"
print(convert_minutes(130))
print(convert_minutes(110))
