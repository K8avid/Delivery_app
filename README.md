# Application De livraison de colis

&emsp;Un utilisateur peut soit envoyer un colis, soit proposer de transporter un colis,  
&emsp;auquel cas il saisit dans l'application le trajet qu'il prévoit d'effectuer.  

&emsp;La gestion des différentes étapes de l'envoi d'un colis se fait grâce à des QR codes :  
&emsp;un code pour la récupération et un autre pour la réception.  


<img src="/coligo_screens.png" alt="Description de l'image" width="600">

## Prérequis pour compiler 

&emsp;Avoir lancé Delivery_App_Server (dans un répository séparé)
&emsp;Avoir installé Android SDK/ Flutter SDK  

## Build
```
1. Modifier le fichier .env avec vos informations
2. Dans un terminal dans le dossier du projet

    flutter pub get    # Récupère les dépendances
    flutter doctor     # Vérifie l’environnement
    flutter build apk  #Génére l'apk

3. récuperer l'apk dans : build/app/outputs/flutter-apk/app-release.apk


```






