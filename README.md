WIP <br>
Deze Script helpt met het maken van back-ups en het uploaden van bestanden naar een (S)FTP server. <br>
Het script komt met een CustomConfig.json file, waarin de gebruiker van het script handmaatig de ip adress, lokale pad, remote pad, etc kan aanpassen.
Dit kan ook worden aangepast via het script als het script vraagt of je de config nog wilt runnen.

Mocht de powershell module die bij deze script gebruikt wordt nog niet geïnstalleerd te zijn, wordt dat automatisch door het script gedaan.
Verder wordt er gevraagd bij de eerste keer dat het script gerund wordt voor de Hostname aan te passen, dit is het IP-adress van de (S)FTP server.
Ook wordt er gevraagd voor de DestinationDirectory aan te passen, dit is de remote directory, waar uit eindelijk de bestanden naartoe worden geupload.

De bestanden van de server worden geupload naar de lokale machine in 'BackUpDirectory' (standaard: /WebsitePusher/BackUpDirectory).
De bestanden worden geupload naar de server vanuit de 'PushDirectory' (standaard: /WebsitePusher/FilesToPush).

Het script vraagt ook om de credentials, dit is dan de username en wachtwoord van de gebruiker op de (S)FTP server.

Flowchart: <br>
<img width="385" height="551" alt="Flowchart2" src="https://github.com/user-attachments/assets/c9dcdfb2-9d74-4e1a-83ea-1b9160c2dd69" /> <br>

