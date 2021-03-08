import React, { useState } from 'react';
import { withStyles } from "@material-ui/core/styles";
import Avatar from '@material-ui/core/Avatar';
import Button from '@material-ui/core/Button';
import CssBaseline from '@material-ui/core/CssBaseline';
import TextField from '@material-ui/core/TextField';

import Link from '@material-ui/core/Link';
import Box from '@material-ui/core/Box';
import LockOutlinedIcon from '@material-ui/icons/LockOutlined';
import Typography from '@material-ui/core/Typography';
import { makeStyles } from '@material-ui/core/styles';
import Container from '@material-ui/core/Container';

function Copyright() {
  return (
    <Typography variant="body2" color="textSecondary" align="center">
      {'Copyright © '}
      <Link color="inherit" href="https://material-ui.com/">
        Your Website
      </Link>{' '}
      {new Date().getFullYear()}
      {'.'}
    </Typography>
  );
}

const useStyles = makeStyles((theme) => ({
  paper: {
    marginTop: theme.spacing(8),
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
  avatar: {
    margin: theme.spacing(1),
    backgroundColor: theme.palette.secondary.main,
  },
  form: {
    width: '100%', // Fix IE 11 issue.
    marginTop: theme.spacing(1),
  }

}));

const DarkerDisabledTextField = withStyles({
  root: {
    marginRight: 8,
    "& .MuiInputBase-root.Mui-disabled": {
      color: "rgba(0, 0, 0, 0.6)" // (default alpha is 0.38)
    }
  }
})(TextField);

export default function SignIn() {
  const classes = useStyles();

  const [checksumValue, setChecksumValue] = useState("");

  return (
    <Container component="main" maxWidth="xs">
      {/* <div>
        <p>You clicked {count} times</p>
        <button onClick={() => setCount(count + 1)}>
          Click me
      </button>
      </div> */}
      <CssBaseline />
      <div className={classes.paper}>
        <Avatar className={classes.avatar}>
          <LockOutlinedIcon />
        </Avatar>
        <Typography component="h1" variant="h5">
          AAX Checksum Resolver
        </Typography>
        <form className={classes.form} noValidate>
          <TextField
            variant="outlined"
            margin="normal"
            required
            fullWidth
            id="checksum"
            label="AAX Checksum"
            name="checksum"
            autoComplete="checksum"
            autoFocus
            onChange={(x) => setChecksumValue(x.target.value)}
          />

          <Button
            fullWidth
            variant="contained"
            // className={classes.submit}
            onClick={() => { alert(checksumValue) }}
          >
            Request Activation Bytes
          </Button>

          <DarkerDisabledTextField
            disabled
            variant="outlined"
            margin="normal"
            fullWidth
            id="activationBytes"
            label="Activation Bytes"
            name="activationBytes"
            autoComplete="activationBytes"
            aria-readonly

            InputProps={{
              readOnly: true
            }}

          />

        </form>
      </div>
      <Box mt={8}>
        <Copyright />
      </Box>
    </Container>
  );
}
