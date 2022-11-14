N="HandleBehavior"
A='"cycle" ｜ "none"'

def acn(n,d):
    joined = ''.join([y.capitalize() for y in d.split('-')])
    return f'{n.lower()}{joined}'

def acMe(n,a):
    asl = [x for x in a.replace('"',' ').replace('|',' ').replace('｜','').split(' ') if x != '']
    defs = '\n'.join([f'{acn(n,d)} :: {n}\n{acn(n,d)} = {n} "{d}"' for d in asl])
    return f'''-- starting {n}
newtype {n} = {n} String
un{n} :: {n} -> String
un{n} ({n} t) = t
{defs}
'''

def decls(n,a):
    asl = [x for x in a.replace('"',' ').replace('|',' ').replace('｜','').split(' ') if x != '']
    defs = '\n  , '.join([f'{acn(n,d)}' for d in asl])
    return f''' , {n}
    , un{n}
    , {defs}
'''
if __name__ == '__main__':
    o = acMe(N,A)
    o_ = decls(N,A)
    print(o)
    print(o_)