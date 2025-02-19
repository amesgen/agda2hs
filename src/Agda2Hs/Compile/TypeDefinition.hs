module Agda2Hs.Compile.TypeDefinition where

import Control.Monad ( unless )

import Data.Maybe ( fromMaybe )

import qualified Language.Haskell.Exts.Syntax as Hs

import Agda.Compiler.Backend

import Agda.Syntax.Common ( namedArg )
import Agda.Syntax.Internal

import Agda.Utils.Impossible ( __IMPOSSIBLE__ )

import Agda2Hs.Compile.Type ( compileType )
import Agda2Hs.Compile.Types
import Agda2Hs.Compile.Utils
import Agda2Hs.HsUtils

compileTypeDef :: Hs.Name () -> Definition -> C [Hs.Decl ()]
compileTypeDef name (Defn {..}) = do
  Clause{..} <- singleClause funClauses
  addContext (KeepNames clauseTel) $ liftTCM1 localScope $ do
    as <- compileTypeArgs namedClausePats
    let hd = foldl (Hs.DHApp ()) (Hs.DHead () name) as
    rhs <- compileType $ fromMaybe __IMPOSSIBLE__ clauseBody
    return [Hs.TypeDecl () hd rhs]
  where
    Function{..} = theDef
    singleClause = \case
      [cl] -> return cl
      _    -> genericError "Not supported: type definition with several clauses"

compileTypeArgs :: NAPs -> C [Hs.TyVarBind ()]
compileTypeArgs ps = mapM (compileTypeArg . namedArg) $ filter keepArg ps

compileTypeArg :: DeBruijnPattern -> C (Hs.TyVarBind ())
compileTypeArg p@(VarP o _) = Hs.UnkindedVar () . hsName <$> showTCM p
compileTypeArg _ = genericError "Not supported: type definition by pattern matching"
