---------------------------------------------------------------------------
Solaris (SPARC) dk_label
---------------------------------------------------------------------------
Type    Name                     Offset Size   Notes
------- ------------------------ ------ ------ ----------------------------
char    dkl_asciilabel[0]~[0x7f] 0x0    0x80   legacy unix ascii label
                            example: "SUN9.0G cyl 4924 alt 2 hd 27 sec 133"
u int   v_version                0x80   0x4    V_VERSION = 0x01
char    v_volume                 0x84   0x8    user definable volume name
u short v_nparts                 0x8c   0x2    V_NUMPAR = NDKMAP = 8
u short p_tag[0]                 0x8e   0x2    partition 0 tag
u short p_flag[0]                0x90   0x2    partition 0 flag
u short p_tag[1]                 0x92   0x2    partition 1 tag
u short p_flag[1]                0x94   0x2    partition 1 flag
u short p_tag[2]                 0x96   0x2    partition 2 tag
u short p_flag[2]                0x98   0x2    partition 2 flag
u short p_tag[3]                 0x9a   0x2    partition 3 tag
u short p_flag[3]                0x9c   0x2    partition 3 flag
u short p_tag[4]                 0x9e   0x2    partition 4 tag
u short p_flag[4]                0xa0   0x2    partition 4 flag
u short p_tag[5]                 0xa2   0x2    partition 5 tag
u short p_flag[5]                0xa4   0x2    partition 5 flag
u short p_tag[6]                 0xa6   0x2    partition 6 tag
u short p_flag[6]                0xa8   0x2    partition 6 flag
u short p_tag[7]                 0xaa   0x2    partition 7 tag
u short p_flag[7]                0xac   0x2    partition 7 flag
                                 0xae   0x2    (integer alignment)
u int   v_bootinfo[0]~[2]        0xb0   0xc    mboot info
u int   v_sanity                 0xbc   0x4    VTOC_SANE = 0x600DDEEE
u int   v_reserved[0]~[9]        0xc0   0x28   (unused)
u int   v_timestamp[0]~[7]       0xe8   0x20   partition timestamp (unused)
u short dkl_write_reinstruct     0x108  0x2    # sectors to skip, writes
u short dkl_read_reinstruct      0x10a  0x2    # sectors to skip, reads
char    dkl_pad[0]~[0x97]        0x10c  0x98   (pad up to 512 bytes)
u short dkl_rpm                  0x1a4  0x2    rotations per minute
u short dkl_pcyl                 0x1a6  0x2    # physical cylinders
u short dkl_apc                  0x1a8  0x2    alternates per cylinder
u short dkl_obs1                 0x1aa  0x2    (used to be gap1)
u short dkl_obs2                 0x1ac  0x2    (used to be gap2)
u short dkl_intrlv               0x1ae  0x2    interleave factor
u short dkl_ncyl                 0x1b0  0x2    # of data cylinders
u short dkl_acyl                 0x1b2  0x2    # of alternate cylinders
u short dkl_nhead                0x1b4  0x2    # of heads in this partition
u short dkl_nsect                0x1b6  0x2    # of 512 byte sectors/track
u short dkl_obs3                 0x1b8  0x2    (was label head offset)
u short dkl_obs4                 0x1ba  0x2    (was physical partition)
int     dkl_cylno[0]             0x1bc  0x4    partition 0 start cylinder
int     dkl_nblk[0]              0x1c0  0x4    partition 0 blocks/sectors
int     dkl_cylno[1]             0x1c4  0x4    partition 1 start cylinder
int     dkl_nblk[1]              0x1c8  0x4    partition 1 blocks/sectors
int     dkl_cylno[2]             0x1cc  0x4    partition 2 start cylinder
int     dkl_nblk[2]              0x1d0  0x4    partition 2 blocks/sectors
int     dkl_cylno[3]             0x1d4  0x4    partition 3 start cylinder
int     dkl_nblk[3]              0x1d8  0x4    partition 3 blocks/sectors
int     dkl_cylno[4]             0x1dc  0x4    partition 4 start cylinder
int     dkl_nblk[4]              0x1e0  0x4    partition 4 blocks/sectors
int     dkl_cylno[5]             0x1e4  0x4    partition 5 start cylinder
int     dkl_nblk[5]              0x1e8  0x4    partition 5 blocks/sectors
int     dkl_cylno[6]             0x1ec  0x4    partition 6 start cylinder
int     dkl_nblk[6]              0x1f0  0x4    partition 6 blocks/sectors
int     dkl_cylno[7]             0x1f4  0x4    partition 7 start cylinder
int     dkl_nblk[7]              0x1f8  0x4    partition 8 blocks/sectors
u short dkl_magic                0x1fc  0x2    DKL_MAGIC = 0xDABE
u short dkl_cksum                0x1fe  0x2    16 bit XOR checksum
                           Total 0x200 bytes (512 bytes). 
---------------------------------------------------------------------------
