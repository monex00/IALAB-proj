import re

# Apriamo il file e leggiamo il contenuto
with open("in.txt", "r") as f:
    content = f.read()

# Cerchiamo tutti i match nel contenuto del file
matches = re.findall(r"giocaControAIn\(giocaContro\(([a-zA-Z0-9]+),([a-zA-Z0-9]+),(\d+)\),(\d+)\)", content)

# Creiamo un dizionario per raggruppare i match per girone
matches_per_girone = {}

# Iteriamo su tutti i match trovati e li inseriamo nel dizionario in base al girone
for match in matches:
    squadra1 = match[0]
    squadra2 = match[1]
    stadio = match[2]
    girone = int(match[3])
    
    if girone not in matches_per_girone:
        matches_per_girone[girone] = []
        
    matches_per_girone[girone].append((squadra1, squadra2, stadio))

# Iteriamo sul dizionario ordinando i match per girone e stampandoli
for girone, matches in sorted(matches_per_girone.items()):
    print(f"Girone {girone}:")
    ripetizioni = {}

    for match in matches:
        squadra1 = match[0]
        squadra2 = match[1]
        stadio = match[2]
        if(ripetizioni.get(squadra1) == None):
            ripetizioni[squadra1] = 1
        else:
            ripetizioni[squadra1] += 1
        
        if(ripetizioni.get(squadra2) == None):
            ripetizioni[squadra2] = 1
        else:
            ripetizioni[squadra2] += 1

        print(f"{match[0]} vs {match[1]} ({match[2]})")

    print(f"Ripetizioni: {ripetizioni}")
