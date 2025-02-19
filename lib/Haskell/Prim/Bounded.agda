
module Haskell.Prim.Bounded where

open import Haskell.Prim
open import Haskell.Prim.Eq
open import Haskell.Prim.Int
open import Haskell.Prim.Maybe
open import Haskell.Prim.Ord
open import Haskell.Prim.Tuple
open import Haskell.Prim.Word

--------------------------------------------------
-- Bounded

record BoundedBelow (a : Set) : Set where
  field
    minBound : a

record BoundedAbove (a : Set) : Set where
  field
    maxBound : a

record Bounded (a : Set) : Set where
  field
    overlap ⦃ below ⦄ : BoundedBelow a
    overlap ⦃ above ⦄ : BoundedAbove a

{-# COMPILE AGDA2HS Bounded existing-class #-}

open BoundedBelow ⦃ ... ⦄ public
open BoundedAbove ⦃ ... ⦄ public

instance
  iBounded : ⦃ BoundedBelow a ⦄ → ⦃ BoundedAbove a ⦄ → Bounded a
  iBounded .Bounded.below = it
  iBounded .Bounded.above = it

instance
  iBoundedBelowNat : BoundedBelow Nat
  iBoundedBelowNat .minBound = 0

  iBoundedBelowWord : BoundedBelow Word
  iBoundedBelowWord .minBound = 0
  iBoundedAboveWord : BoundedAbove Word
  iBoundedAboveWord .maxBound = 18446744073709551615

  iBoundedBelowInt : BoundedBelow Int
  iBoundedBelowInt .minBound = -9223372036854775808
  iBoundedAboveInt : BoundedAbove Int
  iBoundedAboveInt .maxBound = 9223372036854775807

  iBoundedBelowBool : BoundedBelow Bool
  iBoundedBelowBool .minBound = False
  iBoundedAboveBool : BoundedAbove Bool
  iBoundedAboveBool .maxBound = True

  iBoundedBelowChar : BoundedBelow Char
  iBoundedBelowChar .minBound = '\0'
  iBoundedAboveChar : BoundedAbove Char
  iBoundedAboveChar .maxBound = '\1114111'

  iBoundedBelowTuple₀ : BoundedBelow (Tuple [])
  iBoundedBelowTuple₀ .minBound = tt
  iBoundedAboveTuple₀ : BoundedAbove (Tuple [])
  iBoundedAboveTuple₀ .maxBound = tt

  iBoundedBelowTuple : ⦃ BoundedBelow a ⦄ → ⦃ BoundedBelow (Tuple as) ⦄ → BoundedBelow (Tuple (a ∷ as))
  iBoundedBelowTuple .minBound = minBound ; minBound
  iBoundedAboveTuple : ⦃ BoundedAbove a ⦄ → ⦃ BoundedAbove (Tuple as) ⦄ → BoundedAbove (Tuple (a ∷ as))
  iBoundedAboveTuple .maxBound = maxBound ; maxBound

  iBoundedBelowOrdering : BoundedBelow Ordering
  iBoundedBelowOrdering .minBound = LT
  iBoundedAboveOrdering : BoundedAbove Ordering
  iBoundedAboveOrdering .maxBound = GT

-- Sanity checks

private
  _ : addWord maxBound 1 ≡ minBound
  _ = refl

  _ : addInt maxBound 1 ≡ minBound
  _ = refl
