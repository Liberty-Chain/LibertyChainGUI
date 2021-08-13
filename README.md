# Liberty GUI

The Liberty Project

## Development resources

- Github: [https://github.com/Liberty-Chain/LibertyChainGUI](https://github.com/Liberty-Chain/LibertyChainGUI)

## Introduction

Liberty (code name LBT) is an anonymous cryptocurrency created in 2014 by anonymous hacker code name "L", which focuses on privacy, decentralization and extensibilitylbt is committed to becoming an irreplaceable, untraceable, completely anonymous and decentralized encrypted digital currency compared with Bitcoin and its bifurcation, LBT has a higher degree of anonymity. As a decentralized anonymous network system based on blockchain, at the beginning of its establishment, Liberty tried to build a free community autonomous system that can better serve users, a free world that is completely autonomous and belongs to every participant. Liberty is based on blockchain technology and takes decentralized anonymity as its design concept in principle, a "private internet" has been established on distributed nodes and is open to everyone on this basis, Liberty builds a perfect distributed encryption network with precise and rigorous functional design and user-friendly experience, and finally builds a decentralized blockchain consensus society. The strong initial internal structure of Liberty, its internal financial balance, community promotion, business interconnection, value concentration and network expansion will break the solidified idea behind centralized business. Most cryptocurrencies currently exist have transparent and searchable blockchain, including Bitcoin and Ethereum, which means that anyone in the world can view any transaction the address of coins can be associated with individuals in the physical world liberty uses encryption technology to hide sending and receiving addresses and transaction amounts.

### On Windows:

The Liberty GUI on Windows is 64 bits only; 32-bit Windows GUI builds are not officially supported anymore.

1. Install [MSYS2](https://www.msys2.org/), follow the instructions on that page on how to update system and packages to the latest versions

2. Open an 64-bit MSYS2 shell: Use the *MSYS2 MinGW 64-bit* shortcut, or use the `msys2_shell.cmd` batch file with a `-mingw64` parameter

3. Install MSYS2 packages for Liberty dependencies; the needed 64-bit packages have `x86_64` in their names

    ```
    pacman -S mingw-w64-x86_64-toolchain make mingw-w64-x86_64-cmake mingw-w64-x86_64-boost mingw-w64-x86_64-openssl mingw-w64-x86_64-zeromq mingw-w64-x86_64-libsodium mingw-w64-x86_64-hidapi mingw-w64-x86_64-protobuf-c mingw-w64-x86_64-libusb mingw-w64-x86_64-libgcrypt
    ```

    You find more details about those dependencies in the [Liberty documentation](https://github.com/liberty-project/liberty). Note that that there is no more need to compile Boost from source; like everything else, you can install it now with a MSYS2 package.

4. Install Qt5

    ```
    pacman -S mingw-w64-x86_64-qt5
    ```

    There is no more need to download some special installer from the Qt website, the standard MSYS2 package for Qt will do in almost all circumstances.

5. Install git

    ```
    pacman -S git
    ```

6. Clone repository

    ```
    git clone https://github.com/Liberty-Chain/LibertyChainGUI.git
    cd LibertyChainGUI
    ```

7. Build

    ```
    make release-win64 -j4
    cd build/release
    make deploy
    ```
    \* `4` - number of CPU threads to use

The executable can be found in the `.\bin` directory.
