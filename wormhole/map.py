import re
import matplotlib.pyplot as plt

def draw_maze(num_righe, num_colonne, pos_iniziale, pos_finali, celle_occupate, wormholes, cammino):
    # Creazione del labirinto vuoto
    maze = [[' ' for _ in range(num_colonne + 1 )] for _ in range(num_righe + 1)]

    # Disegno delle celle occupate
    for cella in celle_occupate:
        riga, colonna = get_coordinate(cella)
        maze[riga ][colonna ] = '#'

    # Disegno dei wormhole
    wormholeIcons = [
        '⊙', '◎', '◉', '◌', '◍', '◐', '◑', '◒', '◓', '◔', '◕', '◖', '◗', '◘', '◙', '◚', '◛', '◜', '◝', '◞', '◟', '◠', '◡', '◢', '◣', '◤', '◥', '◦', '◧', '◨', '◩', '◪', '◫', '◬', '◭', '◮', '◯', '◰', '◱', '◲', '◳', '◴', '◵', '◶', '◷', '◸', '◹', '◺', '◻', '◼', '◽', '◾', '◿'
    ]
    i = 0
    for wormhole in wormholes:
        inizio, fine = get_coordinate(wormhole[0]), get_coordinate(wormhole[1])
        maze[inizio[0]][inizio[1]] = wormholeIcons[i]
        maze[fine[0]][fine[1]] = wormholeIcons[i]
        i += 1

    # Disegno delle pareti
    for riga in maze:
        riga[0] = '#'
        riga[-1] = '#'
    for colonna in range(len(maze[0])):
        maze[0][colonna] = '#'
        maze[-1][colonna] = '#'

    # Disegno della posizione iniziale e finale
    pos_iniziale = get_coordinate(pos_iniziale)
    for pos_finale in pos_finali:
        pos = get_coordinate(pos_finale)
        maze[pos[0]][pos[1]] = 'F'

    maze[pos_iniziale[0]][pos_iniziale[1]] = 'S'
    # maze[pos_finale[0]][pos_finale[1]] = 'F'

    # Stampa del labirinto
    for riga in maze:
        print(' '.join(riga))
    
    # Disegno del cammino
      # Disegno del cammino 
    # il cammino è una lista di posizioni
    # esempio : [su, giu, dx, sx, tp]
    # dove su = su, giu = giu, dx = destra, sx = sinistra, tp = teletrasporto
    for movimento in cammino:
        if movimento == 'su':
            pos_iniziale = (pos_iniziale[0] - 1, pos_iniziale[1])
        elif movimento == 'giu':
            pos_iniziale = (pos_iniziale[0] + 1, pos_iniziale[1])
        elif movimento == 'dx':
            pos_iniziale = (pos_iniziale[0], pos_iniziale[1] + 1)
        elif movimento == 'sx':
            pos_iniziale = (pos_iniziale[0], pos_iniziale[1] - 1)
        elif movimento == 'tp':
            for wormhole in wormholes:
                if pos_iniziale == wormhole[0]:
                    pos_iniziale = wormhole[1]
                    break
                elif pos_iniziale == wormhole[1]:
                    pos_iniziale = wormhole[0]
                    break
        maze[pos_iniziale[0]][pos_iniziale[1]] = 'X'

    print("\n\n")
    # Stampa del labirinto
    for riga in maze:
        print(' '.join(riga))


def get_coordinate(posizione):
    return int(posizione[0]), int(posizione[1])

# Lettura del file di input
nomeFile = input("Inserisci il nome del file di input: ")
if nomeFile == "":
    nomeFile = "dominioTriplaUscita.pl"

with open(nomeFile, 'r') as file:
    input_text = file.read()
# Estrazione delle informazioni utilizzando le regex
num_righe_match = re.search(r'num_righe\((\d+)\)', input_text)
num_colonne_match = re.search(r'num_colonne\((\d+)\)', input_text)
pos_iniziale_match = re.search(r'iniziale\(pos\((\d+),(\d+)\)\)', input_text)
pos_finale_match = re.findall(r'finale\(pos\((\d+),(\d+)\)\)', input_text)
celle_occupate_matches = re.findall(r'occupata\(pos\((\d+),(\d+)\)\)', input_text)
wormholes_matches = re.findall(r'wormhole\(pos\((\d+),(\d+)\),pos\((\d+),(\d+)\)\)', input_text)
# Estrazione dei valori dalle corrispondenze delle regex
num_righe = int(num_righe_match.group(1))
num_colonne = int(num_colonne_match.group(1))
pos_iniziale = (int(pos_iniziale_match.group(1)), int(pos_iniziale_match.group(2)))
pos_finali = [(int(x[0]), int(x[1])) for x in pos_finale_match ]
#pos_finale = (int(pos_finale_match.group(1)), int(pos_finale_match.group(2)))
celle_occupate = [(int(x[0]), int(x[1])) for x in celle_occupate_matches]
wormholes = [((int(x[0]), int(x[1])), (int(x[2]), int(x[3]))) for x in wormholes_matches]

with open('cammino.txt', 'r') as file:
    input_text = file.read()

cammino = input_text.split(',')
# Disegno del labirinto
draw_maze(num_righe, num_colonne, pos_iniziale, pos_finali, celle_occupate, wormholes,cammino)

