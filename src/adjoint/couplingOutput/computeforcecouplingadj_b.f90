!        Generated by TAPENADE     (INRIA, Tropics team)
!  Tapenade - Version 2.2 (r1239) - Wed 28 Jun 2006 04:59:55 PM CEST
!  
!  Differentiation of computeforcecouplingadj in reverse (adjoint) mode:
!   gradient, with respect to input variables: forceloc machadj
!                alphaadj xadj wadj betaadj
!   of linear combination of output variables: forceloc
!
!     ******************************************************************
!     *                                                                *
!     * File:          computeForceCouplingAdj.f90                     *
!     * Author:        C.A.(Sandy) Mader                               *
!     * Starting date: 08-17-2008                                      *
!     * Last modified: 08-17-2008                                      *
!     *                                                                *
!     ******************************************************************
!
SUBROUTINE COMPUTEFORCECOUPLINGADJ_B(xadj, xadjb, wadj, wadjb, padj, &
&  iibeg, iiend, jjbeg, jjend, i2beg, i2end, j2beg, j2end, mm, yplusmax&
&  , refpoint, nsurfnodesloc, forceloc, forcelocb, nn, level, sps, &
&  righthanded, secondhalo, alphaadj, alphaadjb, betaadj, betaadjb, &
&  machadj, machadjb, machcoefadj, prefadj, rhorefadj, pinfdimadj, &
&  rhoinfdimadj, rhoinfadj, pinfadj, murefadj, timerefadj, pinfcorradj, &
&  liftindex, ii)
  USE bctypes
  USE blockpointers
  USE communication
  USE flowvarrefstate
  USE inputphysics
  USE inputtimespectral
  IMPLICIT NONE
!end if invForce
!!$      
  REAL(KIND=REALTYPE) :: alphaadj, alphaadjb, betaadj, betaadjb
  INTEGER(KIND=INTTYPE), INTENT(IN) :: i2beg
  INTEGER(KIND=INTTYPE), INTENT(IN) :: i2end
  INTEGER(KIND=INTTYPE) :: ii
  INTEGER(KIND=INTTYPE), INTENT(IN) :: iibeg
  INTEGER(KIND=INTTYPE), INTENT(IN) :: iiend
  INTEGER(KIND=INTTYPE), INTENT(IN) :: j2beg
  INTEGER(KIND=INTTYPE), INTENT(IN) :: j2end
  INTEGER(KIND=INTTYPE), INTENT(IN) :: jjbeg
  INTEGER(KIND=INTTYPE), INTENT(IN) :: jjend
  INTEGER(KIND=INTTYPE), INTENT(IN) :: level
  INTEGER(KIND=INTTYPE) :: liftindex
  REAL(KIND=REALTYPE) :: machadj, machadjb, machcoefadj, pinfcorradj
  INTEGER(KIND=INTTYPE), INTENT(IN) :: mm
  REAL(KIND=REALTYPE) :: murefadj, timerefadj
  INTEGER(KIND=INTTYPE), INTENT(IN) :: nn
  INTEGER(KIND=INTTYPE) :: nsurfnodesloc
  REAL(KIND=REALTYPE) :: forceloc(3, nsurfnodesloc), forcelocb(3, &
&  nsurfnodesloc)
  REAL(KIND=REALTYPE), DIMENSION(0:ib, 0:jb, 0:kb), INTENT(IN) :: padj
  REAL(KIND=REALTYPE) :: pinfdimadj, rhoinfdimadj
  REAL(KIND=REALTYPE) :: refpoint(3)
  REAL(KIND=REALTYPE) :: pinfadj, rhoinfadj
  REAL(KIND=REALTYPE) :: prefadj, rhorefadj
  LOGICAL, INTENT(IN) :: righthanded
  LOGICAL, INTENT(IN) :: secondhalo
  INTEGER(KIND=INTTYPE), INTENT(IN) :: sps
  REAL(KIND=REALTYPE), DIMENSION(0:ib, 0:jb, 0:kb, nw), INTENT(IN) :: &
&  wadj
  REAL(KIND=REALTYPE) :: wadjb(0:ib, 0:jb, 0:kb, nw)
  REAL(KIND=REALTYPE), DIMENSION(0:ie, 0:je, 0:ke, 3), INTENT(IN) :: &
&  xadj
  REAL(KIND=REALTYPE) :: xadjb(0:ie, 0:je, 0:ke, 3)
  REAL(KIND=REALTYPE) :: yplusmax
  REAL(KIND=REALTYPE) :: dragdirectionadj(3)
  INTEGER(KIND=INTTYPE) :: i, j, k, kk, l
  REAL(KIND=REALTYPE) :: liftdirectionadj(3)
  REAL(KIND=REALTYPE) :: normadj(iibeg:iiend, jjbeg:jjend, 3), normadjb(&
&  iibeg:iiend, jjbeg:jjend, 3)
  REAL(KIND=REALTYPE) :: padjb(0:ib, 0:jb, 0:kb)
  REAL(KIND=REALTYPE) :: siadj(2, iibeg:iiend, jjbeg:jjend, 3), siadjb(2&
&  , iibeg:iiend, jjbeg:jjend, 3)
  REAL(KIND=REALTYPE) :: sjadj(iibeg:iiend, 2, jjbeg:jjend, 3), sjadjb(&
&  iibeg:iiend, 2, jjbeg:jjend, 3)
  REAL(KIND=REALTYPE) :: skadj(iibeg:iiend, jjbeg:jjend, 2, 3), skadjb(&
&  iibeg:iiend, jjbeg:jjend, 2, 3)
  REAL(KIND=REALTYPE) :: pinfcorradjb, uinfadj, uinfadjb
  REAL(KIND=REALTYPE) :: veldirfreestreamadj(3), veldirfreestreamadjb(3)
  REAL(KIND=REALTYPE) :: winfadj(nw), winfadjb(nw)
!(xAdj, &
!         iiBeg,iiEnd,jjBeg,jjEnd,i2Beg,i2End,j2Beg,j2End, &
!         mm,cFxAdj,cFyAdj,cFzAdj, &
!         cMxAdj,cMyAdj,cMzAdj,yplusMax,refPoint,CLAdj,CDAdj,  &
!        nn,level,sps,cFpAdj,cMpAdj)
!
!     ******************************************************************
!     *                                                                *
!     * Computes the Force coefficients for the current configuration  *
!     * for the finest grid level and specified time instance using the*
!     * auxiliar routines modified for tapenade. This code calculates  *
!     * the result for a single boundary subface and requires an       *
!     * outside driver to loop over mm subfaces and nn domains to      *
!     * calculate the total forces and moments.                        *
!     *                                                                *
!     ******************************************************************
!
! ie,je,ke
! procHalo(currentLevel)%nProcSend, myID
! equations
! nTimeIntervalsSpectral!nTimeInstancesMax
! EulerWall, ...
!nw
!
!     Subroutine arguments.
!
! notice the range of x dim is set 1:2 which corresponds to 1/il
!
!     Local variables.
!
! notice the range of y dim is set 1:2 which corresponds to 1/jl
! notice the range of z dim is set 1:2 which corresponds to 1/kl
!
!     ******************************************************************
!     *                                                                *
!     * Begin execution.                                               *
!     *                                                                *
!     ******************************************************************
!
!===============================================================
! Compute the forces.
!      call the initialization routines to calculate the effect of Mach and alpha
  CALL ADJUSTINFLOWANGLEFORCECOUPLINGADJ(alphaadj, betaadj, &
&                                   veldirfreestreamadj, &
&                                   liftdirectionadj, dragdirectionadj, &
&                                   liftindex)
  CALL PUSHREAL8ARRAY(veldirfreestreamadj, 3)
  CALL CHECKINPUTPARAMFORCECOUPLINGADJ(veldirfreestreamadj, &
&                                 liftdirectionadj, dragdirectionadj, &
&                                 machadj, machcoefadj)
  CALL PUSHREAL8(gammainf)
  CALL PUSHREAL8(rhorefadj)
  CALL PUSHREAL8(prefadj)
  CALL REFERENCESTATEFORCECOUPLINGADJ(machadj, machcoefadj, uinfadj, &
&                                prefadj, rhorefadj, pinfdimadj, &
&                                rhoinfdimadj, rhoinfadj, pinfadj, &
&                                murefadj, timerefadj)
!referenceStateAdj(velDirFreestreamAdj,liftDirectionAdj,&
!      dragDirectionAdj, Machadj, MachCoefAdj,uInfAdj,prefAdj,&
!      rhorefAdj, pinfdimAdj, rhoinfdimAdj, rhoinfAdj, pinfAdj,&
!      murefAdj, timerefAdj)
!(velDirFreestreamAdj,liftDirectionAdj,&
!     dragDirectionAdj, Machadj, MachCoefAdj,uInfAdj)
  CALL SETFLOWINFINITYSTATEFORCECOUPLINGADJ(veldirfreestreamadj, &
&                                      liftdirectionadj, &
&                                      dragdirectionadj, machadj, &
&                                      machcoefadj, uinfadj, winfadj, &
&                                      prefadj, rhorefadj, pinfdimadj, &
&                                      rhoinfdimadj, rhoinfadj, pinfadj&
&                                      , murefadj, timerefadj, &
&                                      pinfcorradj)
  CALL PUSHREAL8ARRAY(skadj, (iiend-iibeg+1)*(jjend-jjbeg+1)*2*3)
  CALL PUSHREAL8ARRAY(sjadj, (iiend-iibeg+1)*2*(jjend-jjbeg+1)*3)
  CALL PUSHREAL8ARRAY(siadj, 2*(iiend-iibeg+1)*(jjend-jjbeg+1)*3)
! Compute the surface normals (normAdj which is used only in 
! visous force computation) for the stencil
! Get siAdj,sjAdj,skAdj,normAdj
!      print *,'getting surface normals'
  CALL GETSURFACENORMALSCOUPLINGADJ(xadj, siadj, sjadj, skadj, normadj, &
&                              iibeg, iiend, jjbeg, jjend, mm, level, nn&
&                              , sps, righthanded)
!     print *,'computing pressures'
  CALL COMPUTEFORCECOUPLINGPRESSUREADJ(wadj, padj)
  CALL PUSHREAL8ARRAY(padj, (ib+1)*(jb+1)*(kb+1))
  CALL PUSHREAL8ARRAY(wadj, (ib+1)*(jb+1)*(kb+1)*nw)
!    print *,'applyingbcs'
  CALL APPLYALLBCFORCECOUPLINGADJ(winfadj, pinfcorradj, wadj, padj, &
&                            siadj, sjadj, skadj, normadj, iibeg, iiend&
&                            , jjbeg, jjend, i2beg, i2end, j2beg, j2end&
&                            , secondhalo, mm)
!   print *,'integrating forces'
! Integrate force components along the given subface
  CALL FORCESCOUPLINGADJ_B(yplusmax, refpoint, siadj, siadjb, sjadj, &
&                     sjadjb, skadj, skadjb, normadj, xadj, padj, padjb&
&                     , wadj, iibeg, iiend, jjbeg, jjend, i2beg, i2end, &
&                     j2beg, j2end, level, mm, nn, machcoefadj, forceloc&
&                     , forcelocb, nsurfnodesloc, ii)
  CALL POPREAL8ARRAY(wadj, (ib+1)*(jb+1)*(kb+1)*nw)
  CALL POPREAL8ARRAY(padj, (ib+1)*(jb+1)*(kb+1))
  CALL APPLYALLBCFORCECOUPLINGADJ_B(winfadj, winfadjb, pinfcorradj, &
&                              pinfcorradjb, wadj, wadjb, padj, padjb, &
&                              siadj, siadjb, sjadj, sjadjb, skadj, &
&                              skadjb, normadj, normadjb, iibeg, iiend, &
&                              jjbeg, jjend, i2beg, i2end, j2beg, j2end&
&                              , secondhalo, mm)
  CALL COMPUTEFORCECOUPLINGPRESSUREADJ_B(wadj, wadjb, padj, padjb)
  CALL POPREAL8ARRAY(siadj, 2*(iiend-iibeg+1)*(jjend-jjbeg+1)*3)
  CALL POPREAL8ARRAY(sjadj, (iiend-iibeg+1)*2*(jjend-jjbeg+1)*3)
  CALL POPREAL8ARRAY(skadj, (iiend-iibeg+1)*(jjend-jjbeg+1)*2*3)
  CALL GETSURFACENORMALSCOUPLINGADJ_B(xadj, xadjb, siadj, siadjb, sjadj&
&                                , sjadjb, skadj, skadjb, normadj, &
&                                normadjb, iibeg, iiend, jjbeg, jjend, &
&                                mm, level, nn, sps, righthanded)
  CALL SETFLOWINFINITYSTATEFORCECOUPLINGADJ_B(veldirfreestreamadj, &
&                                        veldirfreestreamadjb, &
&                                        liftdirectionadj, &
&                                        dragdirectionadj, machadj, &
&                                        machcoefadj, uinfadj, uinfadjb&
&                                        , winfadj, winfadjb, prefadj, &
&                                        rhorefadj, pinfdimadj, &
&                                        rhoinfdimadj, rhoinfadj, &
&                                        pinfadj, murefadj, timerefadj, &
&                                        pinfcorradj, pinfcorradjb)
  CALL POPREAL8(prefadj)
  CALL POPREAL8(rhorefadj)
  CALL POPREAL8(gammainf)
  CALL REFERENCESTATEFORCECOUPLINGADJ_B(machadj, machadjb, machcoefadj, &
&                                  uinfadj, uinfadjb, prefadj, rhorefadj&
&                                  , pinfdimadj, rhoinfdimadj, rhoinfadj&
&                                  , pinfadj, murefadj, timerefadj)
  CALL POPREAL8ARRAY(veldirfreestreamadj, 3)
  CALL CHECKINPUTPARAMFORCECOUPLINGADJ_B(veldirfreestreamadj, &
&                                   veldirfreestreamadjb, &
&                                   liftdirectionadj, dragdirectionadj, &
&                                   machadj, machcoefadj)
  CALL ADJUSTINFLOWANGLEFORCECOUPLINGADJ_B(alphaadj, alphaadjb, betaadj&
&                                     , betaadjb, veldirfreestreamadj, &
&                                     veldirfreestreamadjb, &
&                                     liftdirectionadj, dragdirectionadj&
&                                     , liftindex)
  forcelocb(1:3, 1:nsurfnodesloc) = 0.0
END SUBROUTINE COMPUTEFORCECOUPLINGADJ_B
