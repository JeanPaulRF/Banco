const DIR = "public/";
import multer from "multer";

export const storage = multer.diskStorage({
  //multers disk storage settings
  destination: function(req, file, cb) {
    cb(null, DIR);
  },
  filename: function(req, file, cb) {
    let datetimestamp = new Date();
    cb(
      null,
        datetimestamp.toISOString().replace(/\-|:|\.|Z|T/g, '')
         +
        "-" +
        file.originalname
    );
  }
});

export const upload = multer({
  //multer settings
  storage: storage,
  limits: {
    fileSize: 5e+7
  }
}).single("file");
