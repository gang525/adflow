!        Generated by TAPENADE     (INRIA, Tropics team)
!  Tapenade - Version 2.2 (r1239) - Wed 28 Jun 2006 04:59:55 PM CEST
!  
!  Differentiation of volpym2 in reverse (adjoint) mode:
!   gradient, with respect to input variables: xa xb xc xd xp ya
!                yb yc yd yp za zb zc zd zp
!   of linear combination of output variables: xa xb xc xd xp ya
!                yb yc yd yp vp za zb zc zd zp
!      ==================================================================
!      ================================================================
SUBROUTINE VOLPYM2_B(xa, xab, ya, yab, za, zab, xb, xbb, yb, ybb, zb, &
&  zbb, xc, xcb, yc, ycb, zc, zcb, xd, xdb, yd, ydb, zd, zdb, xp, xpb, &
&  yp, ypb, zp, zpb, vp, vpb)
  USE constants
  USE precision
  IMPLICIT NONE
  REAL(KIND=REALTYPE) :: vp, vpb
  REAL(KIND=REALTYPE), INTENT(IN) :: xa
  REAL(KIND=REALTYPE), INTENT(IN) :: xb
  REAL(KIND=REALTYPE), INTENT(IN) :: xc
  REAL(KIND=REALTYPE) :: xcb, xdb, ycb, ydb, zcb, zdb
  REAL(KIND=REALTYPE), INTENT(IN) :: xd
  REAL(KIND=REALTYPE), INTENT(IN) :: xp
  REAL(KIND=REALTYPE) :: xpb, ypb, zpb
  REAL(KIND=REALTYPE), INTENT(IN) :: ya
  REAL(KIND=REALTYPE) :: xab, xbb, yab, ybb, zab, zbb
  REAL(KIND=REALTYPE), INTENT(IN) :: yb
  REAL(KIND=REALTYPE), INTENT(IN) :: yc
  REAL(KIND=REALTYPE), INTENT(IN) :: yd
  REAL(KIND=REALTYPE), INTENT(IN) :: yp
  REAL(KIND=REALTYPE), INTENT(IN) :: za
  REAL(KIND=REALTYPE), INTENT(IN) :: zb
  REAL(KIND=REALTYPE), INTENT(IN) :: zc
  REAL(KIND=REALTYPE), INTENT(IN) :: zd
  REAL(KIND=REALTYPE), INTENT(IN) :: zp
  REAL(KIND=REALTYPE) :: tempb, tempb0, tempb1, tempb2, tempb3, tempb4, &
&  tempb5, tempb6, tempb7
  tempb = ((ya-yc)*(zb-zd)-(za-zc)*(yb-yd))*vpb
  tempb0 = -(fourth*tempb)
  tempb1 = (xp-fourth*(xa+xb+xc+xd))*vpb
  tempb2 = ((za-zc)*(xb-xd)-(xa-xc)*(zb-zd))*vpb
  tempb3 = -(fourth*tempb2)
  tempb4 = (yp-fourth*(ya+yb+yc+yd))*vpb
  tempb5 = ((xa-xc)*(yb-yd)-(ya-yc)*(xb-xd))*vpb
  tempb6 = -(fourth*tempb5)
  tempb7 = (zp-fourth*(za+zb+zc+zd))*vpb
  xpb = xpb + tempb
  xab = xab + (yb-yd)*tempb7 - (zb-zd)*tempb4 + tempb0
  xbb = xbb + (za-zc)*tempb4 - (ya-yc)*tempb7 + tempb0
  xcb = xcb + (zb-zd)*tempb4 - (yb-yd)*tempb7 + tempb0
  xdb = xdb + (ya-yc)*tempb7 - (za-zc)*tempb4 + tempb0
  yab = yab + tempb3 - (xb-xd)*tempb7 + (zb-zd)*tempb1
  ycb = ycb + (xb-xd)*tempb7 + tempb3 - (zb-zd)*tempb1
  zbb = zbb + tempb6 - (xa-xc)*tempb4 + (ya-yc)*tempb1
  zdb = zdb + tempb6 + (xa-xc)*tempb4 - (ya-yc)*tempb1
  zab = zab + tempb6 + (xb-xd)*tempb4 - (yb-yd)*tempb1
  zcb = zcb + tempb6 - (xb-xd)*tempb4 + (yb-yd)*tempb1
  ybb = ybb + (xa-xc)*tempb7 + tempb3 - (za-zc)*tempb1
  ydb = ydb + tempb3 - (xa-xc)*tempb7 + (za-zc)*tempb1
  ypb = ypb + tempb2
  zpb = zpb + tempb5
END SUBROUTINE VOLPYM2_B
