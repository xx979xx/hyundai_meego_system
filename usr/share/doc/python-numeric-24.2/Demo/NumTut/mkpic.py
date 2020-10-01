import Image
import Numeric
import pickle
g = Image.open('greece.jpg')
greeceRGB = Numeric.fromstring(g.tostring(), 'b')
greeceRGB.shape = (724, 1065, 4)
greeceRGB = greeceRGB[::-3,::3,:3]
greeceRGB = Numeric.transpose(greeceRGB, (1,0,2))
pickle.dump(greeceRGB, open('greece.pik', 'wb'))
