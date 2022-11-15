ELT = "IonModal"
EVS = "ionBreakpointDidChange ionModalDidDismiss ionModalDidPresent ionModalWillDismiss ionModalWillPresent"
def mkev(e, n, l):
    return f'''instance Attr {e}_ I.On{n} Cb where
  attr I.On{n} value = unsafeAttribute {{ key: "{l}", value: cb' value }}

instance Attr {e}_ I.On{n} (Effect Unit) where
  attr I.On{n} value = unsafeAttribute
    {{ key: "{l}", value: cb' (Cb (const (value $> true))) }}

instance Attr {e}_ I.On{n} (Effect Boolean) where
  attr I.On{n} value = unsafeAttribute
    {{ key: "{l}", value: cb' (Cb (const value)) }}'''

if __name__ == "__main__":
    EVS = [x for x in EVS.split(" ") if x != ""]
    for EV in EVS:
        print(mkev(ELT, EV[0].upper()+EV[1:], EV))
    for EV in EVS:
        en = EV[0].upper()+EV[1:]
        print(f'data On{en} = On{en}')