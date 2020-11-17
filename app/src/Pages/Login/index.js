import React from 'react';

import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import { Link } from 'react-router-dom';

const Login = () => {
    const [open, setOpen] = React.useState(false);

    const handleClickOpen = () => {
        setOpen(true);
    };

    const handleClose = () => {
        setOpen(false);
    };
    return (
        <div>
            <Button onClick={handleClickOpen}>
                Login
            </Button>
            <Dialog
                open={open}
                onClose={handleClose}
                aria-labelledby="responsive-dialog-title"
                >
                    <DialogTitle id="responsive-dialog-title">{"Use my current wallet address?"}</DialogTitle>
                    <DialogContent>
                        <DialogContentText>
                            Sending, getting messages costs you some gas!⛽
                        </DialogContentText>
                    </DialogContent>
                    <DialogActions>
                        <Button autoFocus onClick={handleClose} color="primary">
                            <Link to="/"> Disagree </Link>
                        </Button>
                        <Button onClick={handleClose} color="primary" autoFocus>
                            <Link to="/dashboard"> Agree </Link>
                        </Button>
                    </DialogActions>
             </Dialog>
        </div>
    );
}

export default Login;
