import { Router, Request, Response } from "express";
import { config } from "../config/config";
var mssql = require('mssql');

class BancoRouter {
  router: Router;

  constructor() {
    this.router = Router();
  }
  /**
   * @method get
   * @param req 
   * @param res 
   */
  async get_users_prueba(req: Request, res: Response){
    new mssql.ConnectionPool(config).connect().then((pool:any) => {  //Connect to database
      return pool.request().execute('get_users_prueba')              // Execute the SP into database
      }).then((result: { recordset: any; }) => {
        let rows = result.recordset
        res.setHeader('Access-Control-Allow-Origin', '*')
        res.status(200).json(rows);
        mssql.close();
      }).catch((err: any) => {
        res.status(500).send({ message: `${err}`})
        mssql.close();
      });
  }
  //routes that consult in the FrontEnd
  routes() { 
    this.router.get("/", this.get_users_prueba);     
  }
}

const bancoRouter = new BancoRouter();
bancoRouter.routes();

export default bancoRouter.router;
