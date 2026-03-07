import jwt from 'jsonwebtoken';

const SECRET = process.env.JWT_SECRET;

function generatePolicy(principalId, effect, resource) {
  return {
      principalId,
      policyDocument: {
          Version: '2012-10-17',
          Statement: [{
              Action: 'execute-api:Invoke',
              Effect: effect,
              Resource: resource
          }]
      }
  };
}

export const handler = async (event) => {
  const token = event.authorizationToken.replace('Bearer ', '');

  try {
    // decode the token
    const decoded = jwt.verify(token, SECRET);
    
    return generatePolicy(decoded.sub, 'Allow', event.methodArn);
  } catch {
    return generatePolicy('user', 'Deny', event.methodArn);
  }
}