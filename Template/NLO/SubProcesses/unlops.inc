      INTEGER MAXNUP
      PARAMETER (MAXNUP=500)
      INTEGER NUP_H,IDPRUP_H,IDUP_H(MAXNUP),ISTUP_H(MAXNUP),
     # MOTHUP_H(2,MAXNUP),ICOLUP_H(2,MAXNUP)
      DOUBLE PRECISION XWGTUP_H,AQEDUP_H,AQCDUP_H,
     # PUP_H(5,MAXNUP),VTIMUP_H(MAXNUP),SPINUP_H(MAXNUP)
      common/unlops/ XWGTUP_H,AQEDUP_H,AQCDUP_H,
     # PUP_H,VTIMUP_H,SPINUP_H,NUP_H,IDPRUP_H,IDUP_H,ISTUP_H,
     # MOTHUP_H,ICOLUP_H
