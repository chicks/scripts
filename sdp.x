/* 
  00000000  80 00 00 a0 85 cf 16 c3  00 00 00 00 00 00 00 02 ........ ........
  00000010  20 00 02 00 00 00 00 01  00 00 00 01 00 00 00 00  ....... ........
  00000020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 01 ........ ........
  00000030  00 00 00 04 49 4e 41 50  00 00 00 01 00 00 00 0c ....INAP ........
  00000040  53 43 50 3d 41 58 45 31  34 35 30 30 00 00 00 01 SCP=AXE1 4500....
  00000050  00 00 00 16 43 55 53 54  5f 54 45 4c 5f 4e 4f 3d ....CUST _TEL_NO=
  00000060  39 31 39 37 30 32 34 37  37 37 00 00 00 00 00 01 91970247 77......
  00000070  00 00 00 1a 6f 70 65 72  61 74 69 6f 6e 3d 47 45 ....oper ation=GE
  00000080  54 5f 41 4c 4c 5f 42 41  4c 41 4e 43 45 53 00 00 T_ALL_BA LANCES..
  00000090  00 00 00 01 00 00 00 08  52 45 54 52 49 45 56 45 ........ RETRIEVE
  000000A0  00 00 00 00                                      ....
     
    OFFSET    HEX BYTES     FIELD NAME      XDR DATA TYPE                   VALUE         MEANING
    0-3     = 80 00 00 a0 : xid           : unsigned int    :             : 2147483808  : Transaction ID 
    4-7     = 85 cf 16 c3 : call/reply    : union switch    : 2244941507  : None
    8-11    = 00 00 00 00 : msg_type      : enum            : CALL        : Request
    12-15   = 00 00 00 02 : rpc_version   : unsigned int    : 2           : RPC Version 2

    16-19   = 20 00 02 00 : prog_number   : unsigned int    : 536871424   : Program Number
    20-23   = 00 00 00 01 : prog_version  : unsigned int    : 1           : Program Version
    24-27   = 00 00 00 01 : prog_proc     : unsigned int    : 1           : Program Procedure
    28-31   = 00 00 00 00 : auth_cred     : enum            : AUTH_NONE   : No Authentication
    
    32-35   = 00 00 00 00 : auth_cred_bdy : opaque<400>     : Length 0    : No Authentication
    36-39   = 00 00 00 00 : auth_vrfy     : enum            : AUTH_NONE   : No Authentication
    40-43   = 00 00 00 00 : auth_vrfy_bdy : opaque<400>     : Length 0    : No Authentication
    44-47   = 00 00 00 01 : Delimeter???

    48-51   = 00 00 00 04 : ???           : string          : Length 4    : String is 12 bytes long
    52-55   = 49 4e 41 50 : ???           : string          : INAP        : ???
    56-59   = 00 00 00 01 : Delimeter???
    60-63   = 00 00 00 0c : ???           : string          : Length 12   : String is 12 bytes long

    64-67   = 53 43 50 3d : SCP= 
    68-71   = 41 58 45 31 : AXE1
    72-75   = 34 35 30 30 : 4500
    76-79   = 00 00 00 01 : Delimeter???

    80-83   = 00 00 00 16 : ??? (XDR String, length 22)
    84-87   = 43 55 53 54 : CUST
    88-91   = 5f 54 45 4c : _TEL
    92-95   = 5f 4e 4f 3d : _NO=

    96-99   = 39 31 39 37 : 9197
    100-103 = 30 32 34 37 : 0247
    104-107 = 37 37 00 00 : 77 (padded)
    108-111 = 00 00 00 01 : Delimeter???

    112-115 = 00 00 00 1a : ??? (XDR String, length 26)
    116-119 = 6f 70 65 72 : oper
    120-123 = 61 74 69 6f : atio
    124-127 = 6e 3d 47 45 : n=GE

    128-131 = 54 5f 41 4c : T_AL
    132-135 = 4c 5f 42 41 : L_BA
    136-139 = 4c 41 4e 43 : LANC
    140-143 = 45 53 00 00 : ES (padded)

    144-147 = 00 00 00 01 : Delimeter??? 
    148-151 = 00 00 00 08 : ??? (XDR String, length 8)
    152-155 = 52 45 54 52 : RETR
    156-159 = 49 45 56 45 : IEVE
  
    160-163 = 00 00 00 00 : ???
 
  xid = 80 00 00 a0
  enum_msg_type = 85 cf 16 c3
  msg_type = 00 00 00 00 (CALL)
  rpcvers = 00 00 00 02
  
  rpc_prog = 20 00 02 00
  rpc_prog_version = 00 00 00 01
  rpc_procedure = 00 00 00 01
  credentials =  00 00 00 00

  password = 00 00 00 00
  
  
  
  

  struct rpc_msg {
    unsigned int xid;
    union switch (msg_type mtype) {
      enum msg_type {
         CALL  = 0,
         REPLY = 1
      };
      case CALL:
        call_body cbody;
          struct call_body {
            unsigned int rpcvers;      
            unsigned int prog;
            unsigned int vers;
            unsigned int proc;
            opaque_auth  cred;
              struct opaque_auth {
                auth_flavor flavor;
                  enum auth_flavor {
                    AUTH_NONE       = 0,
                    AUTH_SYS        = 1,
                    AUTH_SHORT      = 2
                  };
                opaque body<400>;
              };
            opaque_auth  verf;
              struct opaque_auth {
                auth_flavor flavor;
                  enum auth_flavor {
                    AUTH_NONE       = 0,
                    AUTH_SYS        = 1,
                    AUTH_SHORT      = 2
                  };
                opaque body<400>;
              };
          };
      case REPLY:
        reply_body rbody;
          union reply_body switch (reply_stat stat) {
            case MSG_ACCEPTED:
              accepted_reply areply;
              struct accepted_reply {
                opaque_auth verf;
                union switch (accept_stat stat) {
                  case SUCCESS:
                    opaque results[0];
                  case PROG_MISMATCH:
                    struct {
                      unsigned int low;
                      unsigned int high;
                    } mismatch_info;
                  default:
                    void;
                  } reply_data;
              };
            case MSG_DENIED:
              rejected_reply rreply;
                union rejected_reply switch (reject_stat stat) {
                case RPC_MISMATCH:
                  struct {
                    unsigned int low;
                    unsigned int high;
                  } mismatch_info;
                case AUTH_ERROR:
                  auth_stat stat;
                };

          } reply;
    } body;
  };
  
*/

typedef string SCP<20>;
typedef string CUST_TEL_NO<28>;
typedef string operation<

struct get_balance_request {
  char  SCP[20];
  char  CUST_TEL_NO[28];
  char  operation[11];
};

struct get_balance_response {
 bool   SUCCESS;  
};

program PPAS_SDP {
  version GET_BALANCE_ONLY {
    get_balance_response get_balance(get_balance_request) = 1;
  } = 1;
} = 0x20000200;

