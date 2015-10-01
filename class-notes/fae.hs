type Identifier = String

data FWAE = Num Int
          | Add FWAE FWAE
          | Div FWAE FWAE
          | Id Identifier
          | With Identifier FWAE FWAE
          | Fun Identifier FWAE
          | App FWAE FWAE deriving Show

type Env = [(Identifier, Value)]

data Value = NumV Int
           | ClosureV Identifier FWAE Env deriving Show
            
mlookup :: Identifier -> Env -> Value
mlookup var ((i,v):r)
  | (var == i) = v
  | otherwise = mlookup var r

extend :: Env -> Identifier -> Value -> Env
extend env i v = (i,v):env

numVplus (NumV n) (NumV k) = NumV (n + k)

numVdiv (NumV n) (NumV k) = NumV (div n k)
                             
closureVbody (ClosureV param body env) = body

closureVparam (ClosureV param body env) = param

closureVenv (ClosureV param body env) = env


--interp :: FWAE -> Env -> Value
interp (Num n) env = NumV n
interp (Add lhs rhs) env = numVplus (interp lhs env) (interp rhs env)
interp (Div lhs rhs) env = numVdiv  (interp lhs env) (interp rhs env)
interp (Id i) env = mlookup i env
interp (With bound_id named_expr bound_body) env =
           interp bound_body
           (extend env bound_id (interp named_expr env))
interp (Fun param body) env =
           ClosureV param body env
interp (App fun_expr arg_expr) env =
           interp (closureVbody (interp fun_expr env)) (extend env (closureVparam (interp fun_expr env)) (interp arg_expr env))
