!
!     ******************************************************************
!     *                                                                *
!     * File:          copyADjointStencil.f90                          *
!     * Author:        Andre C. Marta                                  *
!     *                Seongim Choi                                    *
!     * Starting date: 08-03-2006                                      *
!     * Last modified: 11-18-2007                                      *
!     *                                                                *
!     ******************************************************************
!
      subroutine copyADjointStencil(wAdj, xAdj,alphaAdj,betaAdj,MachAdj,&
           machCoefAdj,iCell, jCell, kCell,prefAdj,&
           rhorefAdj, pinfdimAdj, rhoinfdimAdj,&
           rhoinfAdj, pinfAdj,rotRateAdj,rotCenterAdj,&
           murefAdj, timerefAdj,pInfCorrAdj,liftIndex)
!
!     ******************************************************************
!     *                                                                *
!     * Transfer the state variable w to the auxiliary stencil wAdj    *
!     * used by the Tapenade diferentiated routines. It takes into     *
!     * account whether or not the stencil is centered close to a      *
!     * physical block face (not an internal boundary created by block *
!     * splitting) since those do not have halo nodes.                 *
!     *                                                                *
!     * It is assumed that the pointers in blockPointers have already  *
!     * been set.                                                      *
!     *                                                                *
!     ******************************************************************
!
      use blockPointers   ! w, il, jl, kl
!      use indices         ! nw
      use flowVarRefState  !timeref,nw
      use inputPhysics
      use cgnsgrid    !cgnsdoms
      implicit none

!
!     Subroutine arguments.
!
      integer(kind=intType), intent(in) :: iCell, jCell, kCell
      real(kind=realType), dimension(-2:2,-2:2,-2:2,nw), &
                                                     intent(out) :: wAdj
!      real(kind=realType), dimension(-2:3,-2:3,-2:3,3), &
!                                                     intent(out) :: xAdj
      real(kind=realType), dimension(-3:2,-3:2,-3:2,3), &
                                                     intent(out) :: xAdj

      real(kind=realType) :: alphaAdj, betaAdj,MachAdj,MachCoefAdj
      REAL(KIND=REALTYPE) :: prefAdj, rhorefAdj,pInfCorrAdj
      REAL(KIND=REALTYPE) :: pinfdimAdj, rhoinfdimAdj
      REAL(KIND=REALTYPE) :: rhoinfAdj, pinfAdj
      REAL(KIND=REALTYPE) :: murefAdj, timerefAdj
      integer(kind=intType)::liftIndex

      real(kind=realType), dimension(3),intent(out) ::rotRateAdj,rotCenterAdj


!
!     Local variables.
!
      integer(kind=intType) :: ii, jj, kk, i1, j1, k1, i2, j2, k2, l,j
      integer(kind=intType) :: iStart, iEnd, jStart, jEnd, kStart, kEnd

!
!     ******************************************************************
!     *                                                                *
!     * Begin execution.                                               *
!     *                                                                *
!     ******************************************************************
!

      ! Initialize the auxiliary array wAdj 
      do l=1,nw
        do kk=-2,2
          do jj=-2,2
            do ii=-2,2
              wAdj(ii,jj,kk,l) = 0.0
            enddo
          enddo
        enddo
      enddo

      ! Initialize the auxiliary array xAdj 
      do l=1,3
        do kk=-3,2
          do jj=-3,2
            do ii=-3,2
              xAdj(ii,jj,kk,l) = 0.0
            enddo
          enddo
        enddo
      enddo

      ! Copy the wAdj from w
      do l=1,nw
        do kk=-2,2
          do jj=-2,2
            do ii=-2,2
              wAdj(ii,jj,kk,l) = w(iCell+ii, jCell+jj, kCell+kk,l)
            enddo
          enddo
        enddo
      enddo


      ! Copy xAdj from x

!!$      iStart=-2; iEnd=3
!!$      jStart=-2; jEnd=3
!!$      kStart=-2; kEnd=3

      iStart=-3; iEnd=2
      jStart=-3; jEnd=2
      kStart=-3; kEnd=2

      ! Special care needs to be done for subfaces. 
      ! There're no points for -3 and 2 indices

      if(iCell==2) iStart=-2; if(iCell==il) iEnd=1
      if(jCell==2) jStart=-2; if(jCell==jl) jEnd=1
      if(kCell==2) kStart=-2; if(kCell==kl) kEnd=1

      do l=1,3
        do kk=kStart,kEnd
          do jj=jStart,jEnd
            do ii=iStart,iEnd
              xAdj(ii,jj,kk,l) = x(iCell+ii, jCell+jj, kCell+kk,l)
            enddo
          enddo
        enddo
      enddo

      MachAdj = Mach
      MachCoefAdj = MachCoef
      !print *,'getting angle',liftDirection,shape(liftDirection)
      call getDirAngle(velDirFreestream,liftDirection,liftIndex,alphaAdj,betaAdj)
!      call getDirAngle(velDirFreestream,velDirFreestream,liftIndex,alphaAdj,betaAdj)
      !call getDirAngle(velDirFreestream(1), velDirFreestream(2),&
      !     velDirFreestream(3), alphaAdj, betaAdj)

      prefAdj = pRef
      rhorefAdj = rhoref
      pinfdimAdj = pinfdim
      rhoinfdimAdj = rhoinfdim
      rhoinfAdj = rhoinf
      pinfAdj = pInf
      murefAdj = muref
      timerefAdj = timeref
      pInfCorrAdj = pInfCorr

      
      ! Store the rotation center and determine the
      ! nonDimensional rotation rate of this block. As the
      ! reference length is 1 timeRef == 1/uRef and at the end
      ! the nonDimensional velocity is computed.

      j = nbkGlobal
      
      rotCenterAdj = cgnsDoms(j)%rotCenter
      rotRateAdj   = timeRef*cgnsDoms(j)%rotRate
!      rotRateAdj   = cgnsDoms(j)%rotRate

    end subroutine copyADjointStencil
