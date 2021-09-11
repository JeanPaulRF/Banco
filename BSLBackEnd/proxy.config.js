const proxy = [
    {
      context: '/',
      target: '*',
      pathRewrite: {'^/api' : ''}
    }
  ];
  module.exports = proxy;