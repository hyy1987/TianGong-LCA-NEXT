import { deleteProcess } from '@/services/processes/api';
import { DeleteOutlined } from '@ant-design/icons';
import { ActionType } from '@ant-design/pro-components';
import { Button, message, Modal, Tooltip } from 'antd';
import type { FC } from 'react';
import { useCallback, useState } from 'react';
import { FormattedMessage, useIntl } from 'umi';

type Props = {
  id: string;
  version: string;
  buttonType: string;
  actionRef: React.MutableRefObject<ActionType | undefined>;
  setViewDrawerVisible: React.Dispatch<React.SetStateAction<boolean>>;
};
const ProcessDelete: FC<Props> = ({ id, version, buttonType, actionRef, setViewDrawerVisible }) => {
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [isDeleting, setIsDeleting] = useState(false);
  const intl = useIntl();

  const showModal = useCallback(() => {
    setIsModalVisible(true);
  }, []);

  const handleOk = useCallback(() => {
    setIsDeleting(true);
    deleteProcess(id, version)
      .then(async (result: any) => {
        if (result.status === 204) {
          message.success(
            intl.formatMessage({
              id: 'pages.button.delete.success',
              defaultMessage: 'Selected record has been deleted.',
            }),
          );
          setViewDrawerVisible(false);
          setIsModalVisible(false);
          actionRef.current?.reload();
        } else {
          message.error(result.error.message ?? 'Error');
        }
      })
      .finally(() => {
        setIsDeleting(false);
      });
  }, [actionRef, id, setViewDrawerVisible]);

  const handleCancel = useCallback(() => {
    setIsModalVisible(false);
  }, []);

  return (
    <>
      <Tooltip title={<FormattedMessage id='pages.button.delete' defaultMessage='Delete' />}>
        {buttonType === 'icon' ? (
          <>
            <Button shape='circle' icon={<DeleteOutlined />} size='small' onClick={showModal} />
            <Modal
              title={<FormattedMessage id='pages.button.delete' defaultMessage='Delete' />}
              open={isModalVisible}
              onOk={handleOk}
              onCancel={handleCancel}
              confirmLoading={isDeleting}
            >
              <FormattedMessage
                id='pages.button.deleteMessage.areyousureyouwanttodeletethisdata'
                defaultMessage='Are you sure you want to delete this data?'
              />
            </Modal>
          </>
        ) : (
          <>
            <Button size='small' onClick={showModal}>
              <FormattedMessage id='pages.button.delete' defaultMessage='Delete' />
            </Button>
            <Modal
              title={<FormattedMessage id='pages.button.delete' defaultMessage='Delete' />}
              open={isModalVisible}
              onOk={handleOk}
              onCancel={handleCancel}
              confirmLoading={isDeleting}
            >
              <FormattedMessage
                id='pages.button.deleteMessage'
                defaultMessage='Are you sure you want to delete this data?'
              />
            </Modal>
          </>
        )}{' '}
      </Tooltip>
    </>
  );
};

export default ProcessDelete;
