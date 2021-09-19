require('dotenv').config();
import { Router, Application } from "express";
import express from "express";
import * as path from "path";
import bodyParser, { urlencoded, json } from "body-parser";
import BancoRouter from "./routes/BancoRouter";
var mssql = require('mssql');
// router imports goes here


class Server {
  app: Application;

  constructor() {
    this.app = express();
    this.config();
    this.routerConfig();
  }

  config(): void {

    this.app.use(express.static('public'));
    this.app.use('/files', express.static(path.join(__dirname, '../public')));
    // body-parser parsea el contenido proveniente en la solicitud
    // para permitir una interface de tratamiento de datos más fácil
    this.app.use(bodyParser.urlencoded({ extended: true, limit: "100MB" }));
    this.app.use(json());
    this.app.use((_req, res, next) => {
      res.header("Access-Control-Allow-Origin", "*");
      res.header(
        "Access-Control-Allow-Methods",
        "GET, POST, PUT, DELETE, OPTIONS, PATCH"
      );
      res.setHeader("Content-Type", "application/json");
      res.header(
        "Access-Control-Allow-Headers",
        "Origin, X-Requested-With, Content-Type, Accept, Authorization, Access-Control-Allow-Credentials"
      );
      res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
      res.header("Access-Control-Allow-Credentials", "true");
      next(); // chain the another middleware in pipeline
    });
  }

  /**
   * Config of routes
   */
  routerConfig(): void {
    this.app.use("/api/banco", BancoRouter);

    //Set Port



    this.app.listen(process.env.port || 3002, () =>
      console.log(`Listening on port: ${process.env.port || 3002}`)
    );
  }
}

//const server = new Server();
export default new Server().app;
