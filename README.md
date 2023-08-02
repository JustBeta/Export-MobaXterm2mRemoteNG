# Export-MobaXtern2mRemoteNG
conversion du fichier ini de MobaXterm au format MRemoteNG

Pour l'instant, ce script ne prend en charge que les types de conexions que j'utilise.
pour les types non pris en charge, soit vous le faite, soit vous me poser la question.

ce script n'est pas capable de decrypté les mot de passe de MobaXterm.
donc, 2 solution s'offres a vous:
- https://github.com/xillwillx/MobaXterm-Decryptor (ne gere pas le Master Password)
- soit modifié les hash de la section [Credentials] en les remplacants avec les passe en clair.

Exemple:
[Credentials]
Admin Domain=domain\Adminnistrateur:jXQpOwGai1Ydfg==
en:
Admin Domain=domain\Adminnistrateur:LePassEnClair

ce changement permet de mettre a jour les passwords dans toutes les connexions.


# Export-MobaXterm2mRemoteNG
Conversion of MobaXterm's ini file to MRemoteNG format.

Currently, this script only supports the connection types that I use.
For unsupported types, you can either add support for them yourself or ask me a question.

This script is not capable of decrypting MobaXterm passwords.
So, you have two options:
 - Use the MobaXterm password decryptor available at: https://github.com/xillwillx/MobaXterm-Decryptor (Note: It does not handle the Master Password).
 - Manually update the hashes in the [Credentials] section by replacing them with clear text passwords.
   
Example:
[Credentials]
Admin Domain=domain\Adminnistrateur:jXQpOwGai1Ydfg==
With:
Admin Domain=domain\Adminnistrateur:PlainTextPassword

By making this change, you can update passwords for all connections.
