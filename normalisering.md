## Ursprunglig struktur

| uthyrningnummer | datum      | kunduppgifter                           | filmtitel   | speltid |
|-----------------|------------|-----------------------------------------|-------------|---------|
| 101             | 2026-11-01 | Anna Berg, anna@example.com, 070-111111 | Stjärnresan | 119 min |
| 102             | 2026-11-02 | Erik Lind, erik@example.com, 070-222222 | Månjakten   | 99 min  |
| 103             | 2026-11-05 | Anna Berg, anna@example.com, 070-111111 | Månjakten   | 99 min  |

## Normalisering

Vi kan börja med att lyfta ut kunduppgifterna till en separat tabell

| kund_id (PK) | namn      | email            | telefonnummer |
|--------------|-----------|------------------|---------------|
| 1            | Anna Berg | anna@example.com | 070-111111    |
| 2            | Erik Lind | erik@example.com | 070-222222    |

Till skillnad från ursprungstabellen kan nu en kund identifieras med hjälp av ett kund_id istället för en email. Vi
undviker även att behöva uppdatera en kunds data på varje rad i ursprungstabellen om ett telefonnummer skulle ändras
till exempel.

- `kund_id` genereras med `auto_increment`
- `email` blir `unique`

Detta ger oss en ursprungstabell som nu ser ut såhär

| uthyrningnummer | datum      | filmtitel   | speltid |
|-----------------|------------|-------------|---------|
| 101             | 2026-11-01 | Stjärnresan | 119 min |
| 102             | 2026-11-02 | Månjakten   | 99 min  |
| 103             | 2026-11-05 | Månjakten   | 99 min  |

Här kan vi även lyfta ut filmerna till en egen tabell också

| film_id (PK) | filmtitel   | speltid_minuter |
|--------------|-------------|-----------------|
| 1            | Stjärnresan | 119             |
| 2            | Månjakten   | 99              |

Även med denna ändring så får vi dels en möjlighet att ge varje film ett separat unikt id. Samt om uppdateringar skulle
göras till en viss film så behövs inte det ändras på varje plats i ursprungstabellen.

- `film_id` skapas genom `auto_increment`
- Speltid blir istället ett `INT`-fält istället för att vara en text så att speltid antingen kan summeras eller jämföras
  med andra filmers speltid. Namnet på kolumnen blir också ändrat för att göra det enklare att förstå att heltalen
  representerar minuter.

Detta ger oss nu en ursprungstabell som ser ut såhär:

| uthyrningnummer | datum      |
|-----------------|------------|
| 101             | 2026-11-01 |
| 102             | 2026-11-02 |
| 103             | 2026-11-05 |

Nu har vi bara data kvar som inte behövs lyftas ut i en separat tabell. Så nu kan vi istället lägga till två kolumner
med foreign keys till `kund_id` och `film_id`. Vi byter också namn på `uthyrningsnummer` till `uthyrnings_id` och gör
den till primary key med `auto_increment`, så att varje uthyrning får ett eget unikt id.

Vi lägger även till en sammansatt unik nyckel på kombinationen `kund_id` och `film_id`. Det ser till att en kund bara
kan ha en kopia av en film uthyrd åt gången.

> Jag utgår här ifrån att en uthyrning blir borttagen från tabellen när en kund lämnar tillbaka en film.

Detta ger oss då en sluttabell som ser ut såhär:

| uthyrnings_id (PK) | kund_id (FK) | film_id (FK) | datum      |
|--------------------|--------------|--------------|------------|
| 101                | 1            | 1            | 2026-11-01 |
| 102                | 2            | 2            | 2026-11-02 |
| 103                | 1            | 2            | 2026-11-05 |

## Relationer mellan tabellerna

Vi kallar sluttabellen för uthyrning.

- **uthyrning > kund** - många till en: En kund kan finnas i flera uthyrningar
- **uthyrning > film** - många till en: En film kan finnas i flera uthyrningar
- **kund > film** - många till många: Finns inte direkt som en foreign key koppling men den realiseras genom uthyrning
  som fungerar som en kopplingstabell. En film kan hyras av flera kunder och en kund kan hyra flera filmer.





