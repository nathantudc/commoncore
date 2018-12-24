import {NativeModules} from 'react-native'
 
 const {KCommonCore} = NativeModules;
 
 export default class KCore {
 
   static biologicalRecognition (des,cb) {
    KCommonCore.biologicalRecognition(des,cb);
   }
 }
 