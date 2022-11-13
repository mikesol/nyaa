// @ts-check
import { initSchema } from '@aws-amplify/datastore';
import { schema } from './schema';



const { Profile } = initSchema(schema);

export {
  Profile
};