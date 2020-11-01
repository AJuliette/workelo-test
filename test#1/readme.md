# Test #1 (Algo - 📆 Calendrier)

## Objectif
Il s'agit d'un véritable problème auquel nous avons été confronté 🤔 : comment trouvez les créneaux de disponibilités entre plusieurs personnes.

L'idée est d'aider au maximum les entreprises à préparer l'arrivée d'un nouveau collaborateur, en particulier en lui organisant toutes les réunions / rencontres avec les différentes personnes de son équipe... et ça peut faire du monde 😳 !


## Détails
Ansi afin d'aider les RH à **planifier les réunions** des nouvelles recrues, votre mission consiste à développer une méthode permettant de trouver des créneaux disponibles entre 2 agendas.

A partir de l'API de Google Calendar, il est possible de récupérer les `busy slots` d'un employé, disons Sandra, sous la forme :
```
[
  {
    start: 2020-09-01T12:00:00,
    end: 2020-09-01T14:00:00
  },
  {
    start: 2020-09-02T08:30:00,
    end: 2020-09-02T16:00:00
  },
  ...
]
```
Donc dans l'exemple ci-dessus, il faut comprendre que Sandra est occupée le 1er septembre entre 12h et 14h et le lendemain de 8h à 16h.

Pas besoin de vous connecter à l'API de Google, on vous a préparé 2 tableaux avec les busy slots de Sandra (`input_sandra.json`) et Andy (`input_andy.json`).

👉 Que devez-vous faire ?
A partir des 2 tableaux et à partir de la durée du créneau souhaité (par exemple 1h) vous devez créer une méthode qui retourne **les créneaux disponibles**.

Quelques hypothèses pour vous simplifier la vie
1. une journée professionnelle commence à 9h et se termine à 18h
2. ne considérez que les créneaux mutuellement exclusifs - par exemple entre 14h et 16h il y a 2 créneaux exclusifs d'une heure : 14h-15h et 15h-16h (on ne s'embête pas avec les créneaux du genre 14h01-15h01, 14h02-15h02, etc.)
3. si vous souhaitez prendre d'autres hypothèses, pas de problème, précisez-les clairement


---
Bonne chance 💪!

> Si tu as la moindre question ✉️ recrutement-tech@workelo.eu
