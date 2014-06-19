#!/bin/sh

#criando pasta padrão do compilador
mkdir -p "/home/$USER/Portugol-Lua"

#copiando arquivos para a nova pasta
cp -r `pwd`/* /home/$USER/Portugol-Lua/

#making file
cd /home/$USER/Portugol-Lua/

make

#setando PATH
if [ ! -d "/home/$USER/bin" ] ; then
	mkdir -p "/home/$USER/bin"
fi

#copiando script para pasta bin
cp -r /home/$USER/Portugol-Lua/ptlua /home/$USER/bin

#setando script para somente execução
chmod 755 /home/$USER/bin/ptlua

echo "Compilador instalado com sucesso!"
echo "Pode ser necessário reiniciar o computador."

