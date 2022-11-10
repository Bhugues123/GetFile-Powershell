#On récupère la liste des fichiers et on ne prend que ceux qui se terminent en xml
$MonFolder = Get-ChildItem -Path "E:\Content Connector\Recup_Rapport_Intervention\" -File | Where-Object {$_.Name -match 'xml$'}
#On boucle sur l'ensemble des fichiers présents dans le rep
foreach ($MyFile in $MonFolder)
{

    #On recup le contain
    $contain = Get-Content -Path $MyFile.FullName
    #Format XML
    $monXML =[xml] $contain
    #On DL le fichier au format PDF et on le nomme correctement
    Invoke-WebRequest -Uri $monXML.all.url -OutFile ("E:\Content Connector\Rapport_Intervention\{0}.pdf" -f $monXML.all.DocNo)

    #On test l'existance du fichier
    if(Test-Path ("E:\Content Connector\Rapport_Intervention\{0}.pdf" -f $monXML.all.DocNo))
    {

        #Si il existe on move le XML dans "Traite"
        Move-Item $MyFile.FullName -Destination ("E:\Content Connector\Recup_Rapport_Intervention\Traite\{0}" -f $MyFile.name)

    }else{

        #Si il n'existe pas on move le XML dans "Error"
        Move-Item $MyFile.FullName -Destination ("E:\Content Connector\Recup_Rapport_Intervention\Error\{0}" -f $MyFile.name)

    }

}
