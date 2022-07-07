<#
.SYNOPSIS
	Programme de gestion d'annuaire telephonique
.DESCRIPTION
	Ce scipt PowerShell permet de gerer un annuaire telephonique avec plusieurs options (Lister, Ajouter, Supprimer...)
.LINK
	https://github.com/myahia93/Gestion-Annuaire-T-l-phonique.git
.NOTES
	Author: Mohcine YAHIA | Réseaux et Sécurité
#>

#On vérifie si le fichier existe, sinon on le crée
if (!(Test-Path ".\enregistrements.csv")) {
	$newcsv = {} | Select-Object "Nom", "Prenom", "Telephone" | Export-Csv enregistrements.csv -Encoding "UTF8" -NoTypeInformation
}

#Fontions
function ajoutFiche {
	Write-Host -BackgroundColor DarkBlue "                                                   "
	Write-Host -BackgroundColor DarkBlue "                 Ajout d'une fiche                 "
	Write-Host -BackgroundColor DarkBlue "                                                   "
	Write-Host ""

	Write-Host "Veuillez entrez les informations de la nouvelle fiche :"
	$nom = Read-Host "Nom"
	$nom = $nom.ToUpper()
	$prenom = Read-Host "Prenom"
	$tel = Read-Host "Numero de telephone"

	# Insertion
	ADD-content ".\enregistrements.csv" -value "$nom, $prenom, $tel"

	Write-Host "La fiche '$nom, $prenom' a ete ajouter"
}

function supprFiche {
	Write-Host -BackgroundColor DarkBlue "                                                   "
	Write-Host -BackgroundColor DarkBlue "              Suppression d'une fiche              "
	Write-Host -BackgroundColor DarkBlue "                                                   "
	Write-Host ""
	
	Write-Host "Quel fiche voulez-vous supprimer ? :"
	$nom = Read-Host "Nom"
	$file = Import-CSV -Path ".\enregistrements.csv"

	# On verifie si la fiche existe
	[bool] $exist = $false;
	foreach ($fiche in $file) {
		if ($fiche.Nom -match $nom) {
			$exist = $true
		}
	}

	if ($exist) {
		# Suppression de la fiche
		$file | Where-Object Nom -ne $nom | Export-Csv '.\enregistrements.csv' -Encoding "UTF8" -NoTypeInformation
		Write-Host "La fiche '$nom' a ete supprimer"

		# Suppression des lignes vide
		$file = Import-CSV -Path ".\enregistrements.csv"
		$file | Where-Object { $_.PSObject.Properties.Value -ne '' } | Export-Csv '.\enregistrements.csv' -Encoding "UTF8" -NoTypeInformation
	}
	else {
		Write-Host "La fiche '$nom' n'existe pas dans l'annuaire"
	}
}

function listeFiche {
	Write-Host -BackgroundColor DarkBlue "                                                   "
	Write-Host -BackgroundColor DarkBlue "                Liste de l'annuaire                "
	Write-Host -BackgroundColor DarkBlue "                                                   "
	Write-Host ""

	$file = Import-CSV -Path ".\enregistrements.csv"
	
	Write-Host "Nom		Prenom		Telephone"
	Write-Host "-------------------------------------------"
	foreach ($fiche in $file) {
		Write-Host $fiche.Nom"		"$fiche.Prenom"		"$fiche.Telephone
	}

}

function rechercheFiche {
	Write-Host -BackgroundColor DarkBlue "                                                   "
	Write-Host -BackgroundColor DarkBlue "                Recherche de fiche                 "
	Write-Host -BackgroundColor DarkBlue "                                                   "
	Write-Host ""
	
	Write-Host "Quel fiche voulez-vous rechercher ? :"
	$nom = Read-Host "Nom"
	Write-Host ""

	$file = Import-CSV -Path ".\enregistrements.csv"

	# On verifie si la fiche existe et affichage de la fiche
	[bool] $exist = $false;
	Write-Host "Nom		Prenom		Telephone"
	Write-Host "-------------------------------------------"
	foreach ($fiche in $file) {
		if ($fiche.Nom -match $nom) {
			$exist = $true
			Write-Host $fiche.Nom"		"$fiche.Prenom"		"$fiche.Telephone
		}
	}

	if (!$exist) {
		Write-Host "La fiche '$nom' n'existe pas dans l'annuaire"
	}
}

function modifFiche {
	Write-Host -BackgroundColor DarkBlue "                                                   "
	Write-Host -BackgroundColor DarkBlue "             Modification d'une fiche              "
	Write-Host -BackgroundColor DarkBlue "                                                   "
	Write-Host ""
	
	Write-Host "Quel fiche voulez-vous modification ? :"
	$nom = Read-Host "Nom"
	Write-Host ""

	$file = Import-CSV -Path ".\enregistrements.csv"

	# On verifie si la fiche existe et affichage de la fiche
	[bool] $exist = $false;
	foreach ($fiche in $file) {
		if ($fiche.Nom -match $nom) {
			$exist = $true
			Write-Host "Fiche actuelle : "$fiche.Nom"		"$fiche.Prenom"		"$fiche.Telephone
			Write-Host ""
			Write-Host "Veuillez entrez les informations de la nouvelle fiche :"
			$newNom = Read-Host "Nouveau nom"
			$newNom = $newNom.ToUpper()
			$newPrenom = Read-Host "Nouveau prenom"
			$newTel = Read-Host "Nouveau numero de telephone"
			
			$fiche.Nom = $newNom
			$fiche.Prenom = $newPrenom
			$fiche.Telephone = $newTel
		}
	}

	if (!$exist) {
		Write-Host "La fiche '$nom' n'existe pas dans l'annuaire"
	}
 else {
		$file | Export-Csv '.\enregistrements.csv' -Encoding "UTF8" -NoTypeInformation
		Write-Host "La fiche '$nom' a été modifier"
	}
}

function quitter {
	Write-Host -BackgroundColor DarkBlue "                                                   "
	Write-Host -BackgroundColor DarkBlue "                    Au revoir !                    "
	Write-Host -BackgroundColor DarkBlue "                                                   "
	exit
}

# Boucle du programme
do {
	# MENU
	Write-Host ""
	Write-Host -BackgroundColor DarkBlue "                                                   "
	Write-Host -BackgroundColor DarkBlue " -------------Gestionnaire d'Annuaire------------- "
	Write-Host -BackgroundColor DarkBlue " ------------------------------------------------- "
	Write-Host -BackgroundColor DarkBlue " ----------------------Menu----------------------- "
	Write-Host -BackgroundColor DarkBlue "                                                   "
	Write-Host -BackgroundColor DarkBlue "        1. Ajouter une fiche dans l'annuaire       "
	Write-Host -BackgroundColor DarkBlue "        2. Supprimer une fiche                     "
	Write-Host -BackgroundColor DarkBlue "        3. Rechercher une fiche                    "
	Write-Host -BackgroundColor DarkBlue "        4. Modifier une fiche                      "
	Write-Host -BackgroundColor DarkBlue "        5. Lister l'annuaire                       "
	Write-Host -BackgroundColor DarkBlue "        6. Quitter le programme                    "
	Write-Host -BackgroundColor DarkBlue "                                                   "
	Write-Host ""

	do {
		$choix = Read-Host " Veuillez choisir une option (entrer un chiffre de 1 a 6)"    
	} while (($choix.Length -ne 1) -or (!$choix -is [int]) -or ($choix -lt 1) -or ($choix -gt 6))
	Write-Host ""

	switch ($choix) {
		1 { ajoutFiche }
		2 { supprFiche }
		3 { rechercheFiche }
		4 { modifFiche }
		5 { listeFiche }
		6 { quitter }
	}
}while (1)