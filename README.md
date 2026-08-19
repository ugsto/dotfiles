# Dotfiles NixOS

Configuração declarativa de NixOS, Disko e Home Manager para minhas máquinas
Linux. O repositório contém o sistema operacional, o ambiente gráfico Sway,
programas de usuário, temas, segredos gerenciados pelo SOPS e alguns pacotes
customizados.

## Visão geral

O repositório possui duas camadas diferentes:

1. **NixOS**: boot, kernel, hardware, rede, serviços do sistema, usuários,
   Disko, LUKS, Btrfs e drivers.
2. **Home Manager**: Sway, Noctalia, Wofi, terminal, shell, navegadores,
   programas gráficos, Flatpaks, fontes e configurações do usuário.

Essas camadas são aplicadas separadamente neste momento. Instalar uma
configuração NixOS não ativa automaticamente o Home Manager standalone.

Os alvos atuais são:

| Tipo | Alvo | Descrição |
| --- | --- | --- |
| NixOS | `steins-gate` | Computador pessoal atual, com hardware AMD (ainda sem Disko/LUKS; ver [planejamento de reinstalação](#reinstalar-o-steins-gate-com-disko-e-luks)) |
| NixOS | `andrebortoli-workstation` | Workstation profissional, Intel, Disko, LUKS e Btrfs |
| Home Manager | `personal` | Perfil pessoal |
| Home Manager | `professional` | Perfil profissional |

Os perfis `personal` e `professional` compartilham a base, mas o pessoal
adiciona gaming e Flatpaks voltados a hobbies, enquanto o profissional mantém
as ferramentas de trabalho e o `antigravity-cli`. A separação permite que eles
evoluam de forma independente.

O host pessoal usa apenas o cliente NetBird `wt0`; a workstation profissional
usa `wt0` e `wt1`. O firewall bloqueia conexões de entrada por padrão e o SSH
permanece desativado.

## Estrutura do repositório

```text
.
├── flake.nix
├── flake.lock
├── home/
│   ├── common.nix                 # Configuração compartilhada
│   ├── profiles/
│   │   ├── personal.nix           # Perfil Home Manager pessoal
│   │   └── professional.nix       # Perfil Home Manager profissional
│   ├── sway.nix
│   ├── noctalia.nix
│   ├── wofi.nix
│   ├── sops.nix
│   └── ...
├── pkgs/                          # Pacotes e configuração do Neovim
├── secrets/
│   └── secret.yaml                # Segredos criptografados pelo SOPS
└── system/
    ├── configuration.nix          # Base do sistema
    ├── hardware-configuration.nix
    ├── hardware-configuration-andrebortoli-workstation.nix
    ├── disko-andrebortoli-workstation.nix # Particionamento, LUKS e Btrfs
    └── storage-btrfs.nix          # Snapshots, scrub e trim
```

## Requisitos

- Uma ISO live do NixOS em modo UEFI.
- Conexão com a internet.
- Um disco que possa ser apagado integralmente durante a instalação.
- Conhecimento do dispositivo correto, por exemplo `/dev/nvme0n1`.
- Acesso local à máquina para concluir a instalação e ativar o perfil.
- A chave privada age, caso os segredos do SOPS sejam necessários:
  `~/.config/sops/age/keys.txt`.
- Uma chave de segurança FIDO2 (ex.: YubiKey), de preferência duas — uma
  principal e uma de backup — para o desbloqueio do LUKS e o segundo fator de
  login. Ver [FIDO2 para LUKS e login](#fido2-para-luks-e-login).

> **Atenção:** os comandos Disko deste README são destrutivos. Eles apagam
> todas as partições e dados do dispositivo configurado. Confirme o modelo e
> o tamanho do disco com `lsblk` antes de executá-los.

## Instalação da workstation profissional

Esta seção reproduz a instalação do perfil
`nixosConfigurations.andrebortoli-workstation`.

### 1. Inicializar a ISO live

Inicialize a máquina pela ISO do NixOS em modo UEFI e abra um shell root:

```bash
sudo -i
```

Verifique o hardware e o disco:

```bash
lsblk -o NAME,SIZE,MODEL,TYPE,FSTYPE,MOUNTPOINTS
ls /sys/firmware/efi/efivars >/dev/null
```

O arquivo Disko atual aponta para:

```nix
device = "/dev/nvme0n1";
```

Se o instalador identificar outro dispositivo, altere
[`system/disko-andrebortoli-workstation.nix`](system/disko-andrebortoli-workstation.nix) antes de
continuar. Nunca reutilize esse arquivo sem conferir o dispositivo.

### 2. Configurar a rede

Com NetworkManager na ISO, uma rede Wi-Fi pode ser conectada assim:

```bash
nmcli device wifi list
nmcli device wifi connect "NOME_DA_REDE" password "SENHA_DA_REDE"
```

Para uma conexão cabeada, normalmente basta conectar o cabo. Confirme:

```bash
ping -c 3 nixos.org
```

### 3. Disponibilizar o repositório

Clone o repositório em `/mnt/tmp`, que continuará disponível no sistema
instalado após o reboot:

```bash
mkdir -p /mnt/tmp
git clone URL_DO_REPOSITORIO /mnt/tmp/dotfiles
cd /mnt/tmp/dotfiles
```

Se o repositório não estiver acessível pela internet, copie-o de outra máquina
com `scp` ou `rsync`. O importante é que o diretório final exista dentro de
`/mnt`, por exemplo `/mnt/tmp/dotfiles`.

### 4. Conferir o arquivo Disko

O arquivo [`system/disko-andrebortoli-workstation.nix`](system/disko-andrebortoli-workstation.nix)
define o seguinte layout:

```text
/dev/nvme0n1
└── GPT
    ├── ESP 1 GiB, FAT32, montada em /boot
    └── LUKS cryptroot, restante do disco
        └── Btrfs label=nixos
            ├── /root      → /
            ├── /home     → /home
            ├── /nix      → /nix
            ├── /var      → /var
            └── /snapshots → /.snapshots
```

As montagens Btrfs usam `compress=zstd` e `noatime`. O LUKS está configurado
com `allowDiscards = true`, permitindo que o trim atravesse a camada de
criptografia. Isso melhora a manutenção de SSDs, mas revela ao dispositivo
quais blocos estão livres.

### 5. Criar as partições com Disko

Execute o Disko a partir do repositório:

```bash
sudo nix run github:nix-community/disko -- \
  --mode disko \
  ./system/disko-andrebortoli-workstation.nix
```

O processo destruirá o conteúdo de `/dev/nvme0n1` e criará as partições,
formatará o ESP, inicializará o Btrfs e montará tudo em `/mnt`.

#### Senha do LUKS

Quando o Disko solicitar a senha do LUKS, digite a senha **diretamente no
teclado da máquina nova**, de preferência no console local. Nada aparecerá
enquanto a senha é digitada. Não coloque a senha no comando, em scripts ou no
Git.

Use uma senha forte e guarde uma cópia segura: sem ela, os dados do disco não
podem ser descriptografados.

Confirme o resultado:

```bash
lsblk -f
findmnt /mnt
findmnt /mnt/home
findmnt /mnt/nix
findmnt /mnt/var
findmnt /mnt/.snapshots
findmnt /mnt/boot
```

Também é possível listar os subvolumes:

```bash
btrfs subvolume list /mnt
```

A senha continua sendo o método de desbloqueio obrigatório. A chave FIDO2 é
adicionada depois, como um método extra — ver
[FIDO2 para LUKS e login](#fido2-para-luks-e-login).

### 6. Instalar o NixOS

Instale o host usando o flake:

```bash
sudo nixos-install \
  --flake /mnt/tmp/dotfiles#andrebortoli-workstation \
  --no-root-passwd
```

O comando instala o sistema, configura o systemd-boot e grava a configuração
do host. O `--no-root-passwd` deixa a conta `root` bloqueada, que é o
comportamento desejado para esta configuração.

Antes do reboot, é possível verificar a configuração que será instalada:

```bash
nix flake check --no-build /mnt/tmp/dotfiles
```

### 7. Chaves age do SOPS

O sistema e o Home Manager usam segredos criptografados em
[`secrets/secret.yaml`](secrets/secret.yaml). A chave age privada nunca deve
ser commitada.

Antes de instalar e ativar o sistema, copie a chave para os dois locais
necessários. O NixOS usa uma cópia root-only em `/var/lib/sops-nix`; o Home
Manager standalone continua usando uma cópia no home do usuário:

```bash
install -d -m 700 /mnt/var/lib/sops-nix
install -m 600 ~/.config/sops/age/keys.txt \
  /mnt/var/lib/sops-nix/key.txt

install -d -m 700 /mnt/home/kurisu/.config/sops/age
install -m 600 ~/.config/sops/age/keys.txt \
  /mnt/home/kurisu/.config/sops/age/keys.txt
chown -R 1000:100 /mnt/home/kurisu/.config
```

Se a chave estiver em outro lugar, substitua o caminho de origem. A conta
`kurisu` usa atualmente UID/GID `1000`.

Não adie a cópia de `/var/lib/sops-nix/key.txt` para depois do primeiro boot:
o NixOS precisa dela para materializar os segredos do sistema, incluindo os
endereços de gerenciamento do NetBird.

### 8. Reiniciar

```bash
sync
reboot
```

Remova a ISO durante o reboot. No boot seguinte, o firmware deve mostrar o
systemd-boot. O initrd solicitará a senha do LUKS antes de montar o sistema.
Depois que uma chave FIDO2 for inscrita (ver
[FIDO2 para LUKS e login](#fido2-para-luks-e-login)), o initrd tenta a chave
primeiro e só pede a senha se a chave não estiver presente.

### 9. Primeiro acesso

O SSH está desativado nesta configuração. O primeiro acesso deve ser feito
localmente, pelo console da máquina.

Como `security.sudo.wheelNeedsPassword = false`, o usuário `kurisu` pode usar
`sudo` sem senha. A conta root permanece bloqueada quando a instalação foi
feita com `--no-root-passwd`.

Se quiser definir uma senha para o usuário:

```bash
passwd
```

Para definir explicitamente uma senha de root, algo normalmente desnecessário:

```bash
sudo passwd root
```

Não há serviço SSH ativo nesta configuração.

## Ativar o perfil Home Manager

Depois que o sistema iniciar, entre no repositório que foi preservado em
`/tmp/dotfiles`:

```bash
cd /tmp/dotfiles
```

Ative o perfil adequado:

```bash
# Computador pessoal
nix run .#homeConfigurations.personal.activationPackage

# Computador profissional
nix run .#homeConfigurations.professional.activationPackage
```

Durante a primeira execução, o Nix pode perguntar se deve aceitar as
configurações do Cachix do Noctalia. É possível revisar a URL e a chave no
[`flake.nix`](flake.nix) antes de aceitar. Para aceitar explicitamente a
configuração declarada pelo flake:

```bash
NIX_CONFIG="accept-flake-config = true" nix run \
  .#homeConfigurations.professional.activationPackage
```

O Home Manager cria os arquivos em `~/.config`, instala os programas pessoais
e inicia serviços de usuário como:

- `noctalia.service`;
- `gammastep.service`;
- `syncthing.service`;
- `cliphist.service`;
- `sops-nix.service`.

O atalho `Mod4+C` abre o histórico de clipboard no Wofi. Como o histórico pode
conter segredos, ele pode ser limpo com `cliphist wipe` quando necessário.

Saia e entre novamente no Sway após a primeira ativação para que toda a sessão
use a configuração nova. Para verificar:

```bash
systemctl --user is-active noctalia.service
systemctl --user --failed
test -e ~/.config/sway/config && echo "Sway configurado"
test -e ~/.config/noctalia && echo "Noctalia configurado"
```

### Por que a ativação é separada?

Os alvos em `homeConfigurations` são configurações standalone do Home
Manager. O comando `nixos-install` instala apenas o alvo NixOS e não aplica
automaticamente um perfil de usuário standalone.

Por isso, ao instalar uma máquina nova:

1. `nixos-install --flake ...#HOST` instala o sistema;
2. `nix run .#homeConfigurations.PROFILE.activationPackage` instala o ambiente
   pessoal.

O alias antigo `homeConfigurations.kurisu` continua disponível, mas os nomes
recomendados são `personal` e `professional`.

## Operação diária

### Atualizar o sistema NixOS

No computador pessoal:

```bash
sudo nixos-rebuild switch --flake .#steins-gate
```

No Latitude:

```bash
sudo nixos-rebuild switch --flake .#andrebortoli-workstation
```

Para testar sem alterar o boot padrão:

```bash
sudo nixos-rebuild test --flake .#andrebortoli-workstation
```

Para instalar a geração e usá-la no próximo boot:

```bash
sudo nixos-rebuild boot --flake .#andrebortoli-workstation
```

`nixos-rebuild` não particiona nem formata o disco. O Disko participa da
declaração das montagens, mas o comando destrutivo de particionamento deve ser
executado separadamente e somente durante uma instalação/reinstalação.

### Atualizar o Home Manager

```bash
nix run .#homeConfigurations.personal.activationPackage
nix run .#homeConfigurations.professional.activationPackage
```

Normalmente só o perfil correspondente à máquina deve ser ativado.

### Atualizar as entradas do flake

```bash
nix flake update
```

Isso altera o `flake.lock`. Revise o diff antes de aplicar:

```bash
git diff -- flake.lock
nix flake check --no-build
```

### Verificar o estado do sistema

```bash
systemctl --failed
systemctl --user --failed
systemctl list-timers --all | grep -E 'btrfs|fstrim'
findmnt -t btrfs
```

## Armazenamento, snapshots e manutenção

O host `andrebortoli-workstation` importa [`system/storage-btrfs.nix`](system/storage-btrfs.nix), que configura:

- `compress=zstd` e `noatime` nas subvolumes;
- scrub Btrfs semanal em `/`;
- `fstrim` semanal;
- snapshots read-only diários de `/` e `/home` às `03:15`;
- retenção dos 14 snapshots mais recentes de cada conjunto;
- zram como swap, configurado na base do sistema.

Ver os timers:

```bash
systemctl list-timers --all | grep -E 'btrfs|fstrim'
```

Executar manualmente:

```bash
sudo systemctl start btrfs-scrub@-.service
sudo systemctl start fstrim.service
sudo systemctl start btrfs-snapshot.service
```

Listar snapshots:

```bash
sudo btrfs subvolume list /.snapshots
sudo find /.snapshots -mindepth 2 -maxdepth 2 -type d -print | sort
```

Os snapshots são uma proteção local contra alterações acidentais e não são
backup. Eles ficam no mesmo disco criptografado; falha do disco, perda da
senha LUKS ou corrupção grave também pode destruí-los. Mantenha backups
externos.

Para remover manualmente um snapshot antigo, use o caminho exato:

```bash
sudo btrfs subvolume delete '/.snapshots/root/AAAA-MM-DDTHH-MM-SSZ'
```

Não use `rm -rf` para apagar subvolumes Btrfs.

## Como modificar a configuração

### Alterar o sistema comum

Use [`system/configuration.nix`](system/configuration.nix) para mudanças que
devem valer para todos os hosts, como:

- usuário principal e grupos;
- Git;
- políticas de sudo;
- garbage collection do Nix;
- fontes comuns;
- serviços base;
- zram.

Tenha cuidado com valores específicos de hardware. Hardware, sistema de
arquivos e driver de vídeo devem ficar no host correspondente sempre que
possível.

### Alterar um host

Os hosts NixOS são declarados em [`flake.nix`](flake.nix), na seção
`nixosConfigurations`. O helper `mkConfiguration` recebe:

- `hostName`;
- `hardwareModule`;
- `diskModule` opcional;
- `storageModule` opcional;
- `videoDrivers`.

Exemplo:

```nix
my-laptop = mkConfiguration {
  hostName = "my-laptop";
  hardwareModule = ./system/hardware-configuration-my-laptop.nix;
  diskModule = ./system/disko-my-laptop.nix;
  storageModule = ./system/storage-btrfs.nix;
  videoDrivers = [ "modesetting" ];
};
```

Para gerar a configuração inicial de hardware de uma máquina montada em
`/mnt`:

```bash
nixos-generate-config \
  --root /mnt \
  --no-filesystems
```

Use o arquivo gerado como ponto de partida e renomeie-o para o host. Com
Disko, `--no-filesystems` evita que o gerador recrie declarações de sistemas de
arquivos que já pertencem ao módulo Disko.

Antes de usar um novo host, confira:

```bash
nix flake check --no-build
nix build \
  .#nixosConfigurations.my-laptop.config.system.build.toplevel \
  --no-link
```

### Alterar o particionamento

Edite o arquivo Disko do host, por exemplo
[`system/disko-andrebortoli-workstation.nix`](system/disko-andrebortoli-workstation.nix).

Mudanças comuns:

- trocar `device` para o disco correto;
- alterar o tamanho da ESP;
- criar uma subvolume adicional;
- alterar opções Btrfs;
- ajustar o nome do volume LUKS.

Se uma subvolume nova for adicionada, confirme que ela também possui um
`mountpoint` e que o sistema a monta no local esperado. Depois de alterar o
layout, teste primeiro em uma VM ou disco descartável. Aplicar novamente o
modo Disko em um disco existente pode destruir todos os dados.

### Alterar snapshots e trim

Edite [`system/storage-btrfs.nix`](system/storage-btrfs.nix). Atualmente:

- scrub e trim são semanais;
- snapshots são diários;
- a retenção é de 14 snapshots;
- os snapshots cobrem `/` e `/home`.

Se mudar o caminho `/.snapshots`, atualize conjuntamente o módulo Disko e o
módulo de manutenção.

### Organizar os perfis Home Manager

Configurações comuns devem ficar em [`home/common.nix`](home/common.nix).
Configurações específicas ficam em:

- [`home/profiles/personal.nix`](home/profiles/personal.nix);
- [`home/profiles/professional.nix`](home/profiles/professional.nix).

Exemplo de programa somente no perfil profissional:

```nix
{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.algum-programa ];
}
```

Para adicionar um módulo específico, inclua-o apenas no perfil desejado:

```nix
imports = [
  ../common.nix
  ../sway.nix
  ../modulo-profissional.nix
];
```

Evite duplicar configurações compartilhadas entre os dois perfis. O arquivo
`home/personal.nix` na raiz existe apenas como compatibilidade e importa o
perfil pessoal novo.

## SOPS e age

O arquivo [`secrets/secret.yaml`](secrets/secret.yaml) é criptografado com
SOPS/age. O destinatário está declarado em [`.sops.yaml`](.sops.yaml).

Editar um segredo:

```bash
sops secrets/secret.yaml
```

Adicionar ou alterar a chave age exige que a nova chave seja incluída nas
regras do SOPS e que o arquivo seja recriptografado. A cópia usada pelo
NixOS deve ficar somente na máquina, em:

```text
/var/lib/sops-nix/key.txt
```

Para o Home Manager standalone, a cópia do usuário fica em:

```text
~/.config/sops/age/keys.txt
```

Nunca commit:

- `keys.txt`;
- senhas LUKS;
- chaves SSH privadas;
- tokens em texto puro;
- arquivos descriptografados em `secrets/`.

O Home Manager lê a chave por meio de [`home/sops.nix`](home/sops.nix). O
NixOS também usa a mesma chave para os segredos necessários ao NetBird.

O login automático do cliente `wt0` também exige o arquivo root-only
`/var/lib/netbird-wt0.key`, provisionado fora do repositório. O cliente `wt1`
usa o estado persistido pelo próprio NetBird; em uma instalação nova, ele deve
ser autenticado/provisionado antes de depender do login automático.

## Validação e estilo

Antes de commitar alterações:

```bash
nixfmt --check flake.nix home/*.nix home/profiles/*.nix system/*.nix
git diff --check
nix flake check --no-build
```

Para construir um sistema específico sem ativá-lo:

```bash
nix build \
  .#nixosConfigurations.andrebortoli-workstation.config.system.build.toplevel \
  --no-link
```

Para conferir as saídas disponíveis:

```bash
nix flake show
```

O devShell do projeto inclui ferramentas de formatação, lint e detecção de
segredos:

```bash
nix develop
```

## FIDO2 para LUKS e login

A configuração usa uma chave de segurança FIDO2 (ex.: YubiKey) de duas formas
independentes, ambas como um fator **adicional**, nunca como substituto:

1. **Desbloqueio do LUKS no boot** — a senha continua funcionando sempre; a
   chave é só um atalho mais rápido.
2. **Segundo fator no login gráfico** (greetd/tuigreet) — a senha continua
   sendo exigida; a chave (toque, e PIN se configurado) é exigida também.

Nenhuma das duas inscrições é declarativa: o keyslot do LUKS mora no cabeçalho
do disco e o mapeamento do `pamu2fcfg` precisa ser gerado uma vez contra a
chave física. Ambas sobrevivem a `nixos-rebuild switch` normalmente; só se
perdem se o disco for reparticionado (`disko --mode disko`).

### Inscrever a chave no LUKS

Com a chave conectada, na máquina de destino:

```bash
sudo systemd-cryptenroll --fido2-device=list
sudo cryptsetup luksDump /dev/nvme0n1p2   # confira o estado atual dos keyslots
sudo systemd-cryptenroll --fido2-device=auto /dev/nvme0n1p2
```

> **Nunca use `--wipe-slot` neste comando.** Ele apagaria o keyslot da senha
> existente, eliminando o único método de recuperação caso a chave se perca ou
> quebre.

Inscreva uma **segunda chave, de backup**, repetindo o último comando com a
chave reserva conectada. Confirme o resultado:

```bash
sudo cryptsetup luksDump /dev/nvme0n1p2 | grep -A4 -iE 'keyslots:|tokens:'
```

Deve aparecer o keyslot original da senha, mais um keyslot e um token
`systemd-fido2` por chave inscrita.

Teste com um reboot real: com a chave conectada, o boot deve pedir toque (e
PIN, se configurado) em vez da senha. Depois, reinicie **sem** a chave
conectada e confirme que a senha ainda funciona normalmente. Os dois sentidos
devem ser testados.

Para remover a inscrição de uma chave:

```bash
sudo systemd-cryptenroll --wipe-slot=fido2 /dev/nvme0n1p2
```

### Inscrever a chave no login (segundo fator)

O segundo fator é configurado em [`system/security.nix`](system/security.nix)
e vale para todas as máquinas (o mapeamento não depende do host). Gere o
mapeamento com `pamu2fcfg` (pacote `pam_u2f`, já incluído no
`environment.systemPackages` do host):

```bash
pamu2fcfg -o pam://kurisu -i pam://kurisu -u kurisu   # chave principal
pamu2fcfg -o pam://kurisu -i pam://kurisu -n          # chave de backup, sem o prefixo "kurisu:"
```

Os parâmetros `-o`/`-i` precisam ser exatamente iguais a
`security.pam.u2f.settings.origin`/`appid` em `system/security.nix`.

Cole a saída do primeiro comando em
[`system/u2f-mappings`](system/u2f-mappings), e adicione a saída do segundo
comando à mesma linha, separada por `:`. O resultado tem este formato:

```text
kurisu:<keyHandle1>,<pubkey1>,<coseType1>,<opts1>:<keyHandle2>,<pubkey2>,<coseType2>,<opts2>
```

O conteúdo desse arquivo (handles e chaves públicas) não é secreto — pode ser
commitado normalmente. Depois de editar, aplique a configuração:

```bash
sudo nixos-rebuild switch --flake .#andrebortoli-workstation
```

**Antes de aplicar**, abra um TTY livre (`Ctrl+Alt+F2`) e confirme que o login
por senha funciona ali — `/etc/pam.d/login` não exige a chave, então esse
console continua sendo a rota de recuperação caso algo saia errado no greetd.

Depois de aplicar, reinicie o greetd (`sudo systemctl restart greetd`) e teste:

- Login normal: usuário → toque na chave → senha → sessão inicia.
- Sem a chave conectada: o login deve **falhar** mesmo com a senha correta.
- Um usuário sem entrada em `u2f-mappings` ainda deve conseguir logar (efeito
  de `nouserok`).

Se perder a chave: a senha do LUKS sempre funciona (ela nunca é removida). Já
o login trava sem a chave — as rotas de recuperação são, em ordem: o TTY
(`Ctrl+Alt+F2`), uma geração anterior do systemd-boot (que não tem a regra de
u2f em `/etc/pam.d/greetd`), ou a chave de backup, se uma segunda tiver sido
inscrita.

## Reinstalar o steins-gate com Disko e LUKS

O `steins-gate` ainda roda em ext4 puro, sem Disko e sem criptografia,
instalado da forma tradicional (imperativa). Não existe camada declarativa
para "converter" esse disco em uso — a única forma de aplicar o layout
LUKS/Btrfs é reparticionar e reinstalar, exatamente como foi feito para a
`andrebortoli-workstation`.

O arquivo [`system/disko-steins-gate.nix`](system/disko-steins-gate.nix) já
existe no repositório, com o mesmo layout (ESP + LUKS `cryptroot` + Btrfs com
as mesmas subvolumes), mas **ainda não está referenciado em
[`flake.nix`](flake.nix)** — a troca de `hardwareModule`/`diskModule` do host
`steins-gate` deve ser feita como parte da própria reinstalação, não antes,
porque o `steins-gate` atual continua sendo o ext4 real em uso. Ligar o módulo
Disko antes da reinstalação faria o próximo `nixos-rebuild switch` tentar
montar um layout LUKS/Btrfs que ainda não existe no disco.

> **Este procedimento é destrutivo.** Faça um backup verificado (restaurável)
> antes de continuar.

1. **Backup.** Copie para mídia externa e confirme que a cópia é restaurável:
   `/home`, `~/.config/sops/age/keys.txt`, `/var/lib/sops-nix/key.txt`,
   `/var/lib/netbird-wt0.key`, e qualquer branch git local ainda não
   publicada.
2. **Confirmar o disco** a partir da ISO live:
   ```bash
   lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL
   ls -l /dev/disk/by-id/ | grep -v part
   ```
   Edite `device` em `system/disko-steins-gate.nix` para o caminho `by-id`
   correto (evite `/dev/nvme0n1`: prefira `by-id`, que sobrevive a mudanças de
   enumeração do controlador).
3. **Ligar o Disko no host**, em `flake.nix`:
   ```nix
   ${hostname} = mkConfiguration {
     hostName = hostname;
     hardwareModule = ./system/hardware-configuration-steins-gate.nix;
     diskModule = ./system/disko-steins-gate.nix;
     storageModule = ./system/storage-btrfs.nix;
     videoDrivers = [ "amdgpu" ];
     netbirdClients = [ /* mantidos */ ];
   };
   ```
4. **Remover as declarações antigas de sistema de arquivos** de
   `system/hardware-configuration-steins-gate.nix` — o Disko passa a gerar
   `fileSystems`/`swapDevices` automaticamente:
   - `fileSystems."/"`
   - `fileSystems."/boot"`
   - `swapDevices`

   Note que isso remove a partição de swap dedicada; hibernação deixa de ser
   possível (o swap em runtime continua coberto pelo `zramSwap.enable` já
   existente na configuração base).
5. **Particionar e instalar**, seguindo os mesmos passos das seções
   [3](#3-disponibilizar-o-repositório) a [7](#7-chaves-age-do-sops) acima,
   trocando `disko-andrebortoli-workstation.nix` por `disko-steins-gate.nix` e
   o alvo do flake por `steins-gate`.
6. **Antes do primeiro login gráfico**, garanta que
   [`system/u2f-mappings`](system/u2f-mappings) já tenha uma entrada válida
   (ou dependa de `nouserok`) — como `security.pam.u2f` está em
   `system/security.nix`, compartilhado entre hosts, o greetd já vai exigir a
   chave FIDO2 desde o primeiro boot.
7. **Inscrever a chave FIDO2** no LUKS recém-criado, seguindo
   [Inscrever a chave no LUKS](#inscrever-a-chave-no-luks) acima, com o
   dispositivo correto do `steins-gate`.

## Recuperação

### Escolher uma geração anterior

No boot, selecione uma geração anterior no systemd-boot. Depois, torne-a a
configuração atual quando estiver satisfeito:

```bash
sudo nixos-rebuild switch --rollback
```

### Recuperar a configuração do usuário

O Home Manager mantém gerações no perfil do usuário:

```bash
home-manager generations
```

Se o comando não estiver no `PATH`, use a ativação do perfil atual ou rode
novamente o flake:

```bash
NIX_CONFIG="accept-flake-config = true" nix run \
  .#homeConfigurations.professional.activationPackage
```

### Reinstalar o sistema

1. Inicialize pela ISO live.
2. Confirme o dispositivo correto.
3. Execute o Disko novamente, sabendo que ele apagará o disco.
4. Instale o host NixOS.
5. Restaure a chave age.
6. Reative o perfil Home Manager.
7. Restaure os dados a partir de backup.

Não existe recuperação dos dados do disco apenas a partir deste repositório:
ele contém a descrição da máquina, não uma cópia dos dados pessoais.

## Resumo rápido

Instalação nova da workstation profissional:

```bash
sudo -i
lsblk -o NAME,SIZE,MODEL,TYPE,FSTYPE,MOUNTPOINTS
mkdir -p /mnt/tmp
git clone URL_DO_REPOSITORIO /mnt/tmp/dotfiles
cd /mnt/tmp/dotfiles

# Confirme o disco antes deste comando destrutivo.
sudo nix run github:nix-community/disko -- \
  --mode disko \
  ./system/disko-andrebortoli-workstation.nix

# Digite a senha do LUKS diretamente na máquina nova quando solicitado.
sudo nixos-install \
  --flake /mnt/tmp/dotfiles#andrebortoli-workstation \
  --no-root-passwd

reboot
```

Depois do primeiro boot:

```bash
cd /tmp/dotfiles
NIX_CONFIG="accept-flake-config = true" nix run \
  .#homeConfigurations.professional.activationPackage
```

Para o computador pessoal, use `steins-gate` no alvo NixOS e `personal` no
alvo Home Manager. Para a workstation profissional, use
`andrebortoli-workstation` e `professional`.
